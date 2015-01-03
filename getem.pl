#!/opt/local/bin/perl -w
  my $name = $0; $name =~ s'.*/''; # remove path--like basename
  my $usage = "usage:\n$name [-opt1] [-opt2] [-opt3]";

  use strict;
  use warnings;

  use HTTP::Cookies;
  use WWW::Mechanize;
# use WWW::Mechanize::GZip;
  use Compress::Zlib;
  use Data::Dumper;
  use HTML::Tree;

  my $debug = ''; # 'gallery links code lines';
  my $cj   = HTTP::Cookies->new( file => "/Users/steve/cookie.jar", autosave => 1, ignore_discard => 1 );
  my $mech = WWW::Mechanize->new( autocheck => 1, cookie_jar => $cj );
  $mech->agent_alias( "Mac Mozilla" );
  # my $mech2 = $mech->clone();

# print $WWW::Mechanize::HAS_ZLIB;
  $WWW::Mechanize::HAS_ZLIB = 0;

  my $gurl;
  my $i=0;
  my $test     = 'https://www.deviantart.com/';
  my $user     = 'perlygatekeeper';
  my $response = $mech->get( $test );
  if ( not $mech->content =~ /$user/ ) {
    login();
  }

  my $image_links;

# ==== LOAD PREGATHERED IMAGE LINKS ====
  my $gallery_file="images.out";
  if ( -f $gallery_file ) {
    use IO::File;
    my $fh = new IO::File;
    if ($fh->open("< $gallery_file")) {
	  my @lines = <$fh>;
	  print "Loaded " . scalar(@lines) . " lines.\n" if ( $debug =~ /lines/ );
	  my $code = join('', map {chomp; $_} @lines );
	  print "code is " . length($code) . " bytes long.\n" if ( $debug =~ /code/ );
	  print "code (" . substr($code,0,100) . ")\n" if ( $debug =~ /code/ );
	  if ( not eval "$code" ) { print "eval of \$code failed: '$@'\n"; }
      print "debugging \$image_links is a " . ref($image_links) . ".\n" if ($debug=~/cache_load/);;
      $fh->close;
    }
    print "Loaded images.out\n";
  } else {
# ==== GATHER LINKS FOR GALLERIES' PAGES ====
    my $root_url  = "http://showalittlemore.deviantart.com/gallery";
    my $root_page = $mech->get($root_url);
    my $tree  = HTML::Tree->new();

    print "root_page is '" . length($root_page->content()) . "' characters long.\n" # . $root_page->content();
	  if ($debug=~/character_count/);

    my $root =  $tree->parse($root_page->content());
    my $gallery_folders_root = $root->look_down("_tag" => "div", "class" => "gr-body");
  
#   print "gallery_folders_root is '" . $gallery_folders_root->as_HTML() . "'\n";

    my @gallery_names = map(
	  { $_->{_content}[0];  }
      $gallery_folders_root->look_down("_tag" => "div", "class" => "tv150-tag")
    );
#   print "_content: " . join("\n", @{$gallery_names[0]->{_content}} ) . "\n";

    my @gallery_links = map(
	  { $_->attr('href'); }
      $gallery_folders_root->look_down("_tag" => "a", "class" => "tv150-cover")
    );

  #   print join("\n", @gallery_links) . "\n"; exit 0;

    my(@g);
    for ( $i=0; $i<=$#gallery_links; $i++) {
	  $tree->eof(); $tree->delete(); $tree = HTML::Tree->new();
      my $gallery_id = $gallery_links[$i];   $gallery_id =~ s,.*/,,;
	  my $gallery_page = $mech->get($gallery_links[$i]);
#     print "gallery_page for " . $gallery_names[$i] . " is '" . length($gallery_page->content()) . "' characters long.\n" ;
      my $root = $tree->parse($gallery_page->content());
	  my $pagination = $root->look_down( "_tag" => "div", "class" => "pagination" );
	  my @page_links = $pagination->look_down( "_tag" => "li", "class" => "number" );
      my $number_of_pages = 1;
	  if (@page_links) {
#       print $page_links[$#page_links]->{_content}[0]->as_HTML() . "\n";
        $number_of_pages = $page_links[$#page_links]->{_content}[0]{_content}[0];
	  }

      push( @g, { id    => $gallery_id,
                  url   => $gallery_links[$i],
                  name  => $gallery_names[$i],
	              pages => $number_of_pages,
                }
      )
    }

#   foreach my $gallery_page (@g) {
#     print Dumper($gallery_page);
#   }

    my $template = "http://showalittlemore.deviantart.com/gallery/GALLERY_ID?offset=OFFSET";

    my $image_links;

# ==== GATHER IMAGES LINKS ====
    foreach my $gallery ( @g ) {
      my $gallery_id = $gallery->{id};
      my $gallery_pages = $gallery->{pages};
	  print "Processing gallery '" . $gallery->{name} . "'.\n";
      foreach my $i (  0 ..  ($gallery_pages-1) ) {
        my $offset = 24 * $i;
        my $url = $template;
	    $url =~ s/OFFSET/$offset/;
        $url =~ s/GALLERY_ID/$gallery_id/;
	    print "Extracting links for gallery image pages from '$url'\n";
        $mech->get( $url, ':content_file' => './Temp.html' );
        $mech->get( $url );
        map { $image_links->{$_->url_abs} = $_; }
	      $mech->find_all_links( url_regex => qr(http://[-a-zA-Z0-9]+\.deviantart\.com/art/[^#]+$) );
	    print "  now have " . scalar(keys %$image_links) . " links for image view pages.\n";
      }
    }

# ==== CACHE IMAGES LINKS ====
    print "Dumping image_links...\n";
    my $outfile="images.out";
    open(OUTFILE,">$outfile") || die("$name: Cannot write to '$outfile': $!\n");
    print OUTFILE Dumper('image_links',$image_links);
    close(OUTFILE);
    print "Dumped image_links to images.out\n";
    # foreach my $image_url ( keys %$image_links ) {
    #   print "$image_url\n";
    # }
  }

  # my $outfile="LostGalleryLinks.txt";
  # open(LOST,">$outfile") || die("$name: Cannot write to '$outfile': $!\n");
    my( $img_url, $all_images );
    sub by_width { $b->width <=> $a->width; }

# ==== LOOP OVER IMAGE LINKS ====
  for $gurl ( keys %$image_links ) {
    printf "Loading %-40s\n", $gurl;
# this captured a image's html file to numbered files
#   $mech->get( $gurl, ':content_file' => "file" . $i++);
    $mech->get( $gurl );

# first try for a download link
	my $img_link = $mech->find_link( text_regex => qr/Download Image/);
	if (defined $img_link) {
	  # print "\n"; next;
	  $img_url = $img_link->url_abs;
	} else {
	  $all_images=scalar($mech->images);
	  @$all_images = sort by_width grep ( ( defined $_->width() and $_->width() > 100 ), @$all_images);
	  next if (not @$all_images);
	  $img_url = $all_images->[0]->url();;
	} 
	my $filename = $img_url;
	$filename =~ s[^.+/][];
	$filename =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	if ( -f $filename ) {
	  printf "  found %-20s already here\n", $img_url, $filename;
	} else {
	  printf "  fetching %-40s\n %-20s\n", $img_url, $filename;
	  $mech->get( $img_url, ':content_file' => "$filename" );
	}
	# print "   ", -s $filename, " bytes\n";
  }
  # close(LOST);

exit 0;

sub login {
  my $user     = 'perlygatekeeper';
  my $pass     = 'sdp12sdp';
  my $remember = '1';
  my $login    = 'https://www.deviantart.com/users/rockedout';

  # $cookie_jar->set_cookie( $version, $key, $val, $path, $domain, $port, $path_spec,
  # $secure, $expires, $discard, $extra );

  my $response = $mech->get( $login );
# print $response->content();
  $response = $mech->submit_form(
    form_id => 'form-login',
    fields => {
      username    => $user,
      password    => $pass,
      ref         => $login,
      remember_me => $remember,
    }    
  );
  print $response->content();


  print "\n";
  print "Set Cookie Jar?\n";
  print $mech->cookie_jar->as_string();
  print "\n";
}

__END__


$mech->form_name( 'form-login' );

$mech->set_fields(
    USERID => $username,
    PASSWORD => $password,
    DV_DATA => $dv_data
);    
    
$mech -> submit();

form id="form-login" action="https://www.deviantart.com/users/login" method="post">
input name="ref" value="" type="hidden"
input name="username" type="text"
input name="password" type="password"
input name="remember_me" value="1"
input name="action" type="submit" value="Login"

<form style="padding:12px" id="form-login" action="https://www.deviantart.com/users/login" method="post">
<input type="hidden" id="loginbar-ref" name="ref" value="">
Username or Email
<input id="login-username" name="username" type="text" class="itext" accesskey="u" spellcheck="false"
Password
<input id="login-password" name="password" type="password" class="itext" accesskey="p"
<input type="checkbox" class="checkbox" checked="checked" id="login-remember-me" name="remember_me" value="1" style="vertical-align: middle"> Stay logged in
<input name="action" type="submit" value="Login" class="ibutton" style="width:12ex"></span>
</form>

http://abrito.deviantart.com/gallery/
http://adamhughes.deviantart.com/gallery/
http://ancillatilia.deviantart.com/gallery/
http://ariane-saint-amour.deviantart.com/gallery/
http://ariane-saint-amour.deviantart.com/gallery/28048468
http://ariane-saint-amour.deviantart.com/gallery/28115995
http://ariane-saint-amour.deviantart.com/gallery/30067161
http://ariane-saint-amour.deviantart.com/gallery/30067188
http://ariane-saint-amour.deviantart.com/gallery/30067219
http://ariane-saint-amour.deviantart.com/gallery/30067223
http://ariane-saint-amour.deviantart.com/gallery/34099004
http://ariane-saint-amour.deviantart.com/gallery/34128584
http://browse.deviantart.com/artisan/jewelry/
http://browse.deviantart.com/artisan/leather/
http://browse.deviantart.com/artisan/metalwork/
http://browse.deviantart.com/artisan/miniatures/
http://browse.deviantart.com/artisan/misc/
http://browse.deviantart.com/artisan/origami/
http://browse.deviantart.com/artisan/woodworking/
http://browse.deviantart.com/designs/tattoos/
http://browse.deviantart.com/designs/vehicular/
http://browse.deviantart.com/photography/people/emotive/
http://browse.deviantart.com/photography/people/fetish/
http://browse.deviantart.com/photography/people/glamour/
http://browse.deviantart.com/photography/people/nude/
http://browse.deviantart.com/photography/people/pinup/
http://browse.deviantart.com/resources/lineart/
http://browse.deviantart.com/resources/tutorials/
http://browse.deviantart.com/resources/vector/
http://browse.deviantart.com/traditional/drawings/fantasy/
http://browse.deviantart.com/traditional/drawings/portraits/
http://browse.deviantart.com/traditional/typography/calligraphy/
http://cellar-fcp.deviantart.com/gallery/
http://cyanidemishka.deviantart.com/gallery/
http://daggerpoint.deviantart.com/gallery
http://ebas.deviantart.com/gallery/
http://fbuk.deviantart.com/gallery/
http://grodpro.deviantart.com/gallery/
http://harnois75.deviantart.com/gallery/
http://hely29.deviantart.com/gallery/
http://insuh.deviantart.com/gallery/
http://intelkuritsa.deviantart.com/gallery/
http://miss-mosh.deviantart.com/gallery/
http://mjranum.deviantart.com/gallery/

http://ophelia-overdose.deviantart.com/gallery/
http://photoport.deviantart.com/gallery/
http://rekit.deviantart.com/gallery/
http://showalittlemore.deviantart.com/gallery/
http://sideshowsito.deviantart.com/gallery/

http://vanessalake.deviantart.com/gallery/
http://vinz-el-tabanas.deviantart.com/gallery/
http://vishstudio.deviantart.com/gallery/
http://zemotion.deviantart.com/gallery/
http://zlty-dodo.deviantart.com/gallery/

