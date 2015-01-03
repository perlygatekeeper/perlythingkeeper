#!/usr/bin/perl -w
my $name = $0; $name =~ s'.*/''; # remove path--like basename

use strict;
use warnings;

use lib "/opt/local/lib/perl5/vendor_perl/5.16.3";
use HTTP::Cookies;
use WWW::Mechanize;
use Compress::Zlib;
use Data::Dumper;
use HTML::Tree;

my $debug = ''; # 'gallery links code lines';
my $cj   = HTTP::Cookies->new( file => "/Users/steve/cookie.jar", autosave => 1, ignore_discard => 1 );
my $mech = WWW::Mechanize->new( autocheck => 1, cookie_jar => $cj );
$mech->agent_alias( "Mac Mozilla" );

my $root_url  = 'http://thingiverse.com/';
my $root_page = $mech->get($root_url);

my $user     = 'perlygatekeeper';

# Defaults
my %opt = (
   dir   => ".",
   thing => "398548",
   ua    => "Mozilla/1.0",
   query => "",
   'user'     => 'perlygatekeeper';
   'password' => 'sdpsdp';
);

# Options from the commandline.
GetOptions(
   'verbose'  => \$opt{'verbose' },
   'help'     => \$opt{'help'    },
   'thing=i'  => \$opt{'thing'   },
   'ua=s'     => \$opt{'ua'      },   # user agent
   'dir=s'    => \$opt{'dir'     },
   'user'     => \$opt{'user'    },
   'password' => \$opt{'password'},
);

# Compose our base URL for images.google.com.
$opt{'query'} = uri_escape($opt{'query'});

my $url = "${root_url}thing::$opt{'thing'}";

# Validate input and display help if needed.
&help if ($opt{'help'} || !$opt{'thing'});

if ( not $mech->content =~ /user/ ) {
  print "logging in.\n" if ($opt{'debug'});
  login($opt);
  print "logged in now.\n" if ($opt{'debug'});
} else {
  print "already logging in.\n" if ($opt{'debug'});
}

exit 0;

sub login {
  my $opt = shift;
  my $remember = '1';
  my $login    = 'https://www.thingiverse.com';
  # $cookie_jar->set_cookie( $version, $key, $val, $path, $domain, $port, $path_spec,
  # $secure, $expires, $discard, $extra );
  $mech->follow_link( text_regex => qr/Sign\s+In/i );
# print $response->content();
  $response = $mech->submit_form(
    form_id => 'sso-sign-in-form',
    fields => {
      'username'    => $user,
      'password'    => $pass,
      'ref'         => $login,
      'remember-me' => $remember,
    }    
  );
  print $response->content();
  print "\n";
  print "Set Cookie Jar?\n";
  print $mech->cookie_jar->as_string();
  print "\n";
}

__END__
# use WWW::Mechanize::GZip;
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

__END__

-----------------------------------------
DEVIENTART.COM LOGIN

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

-----------------------------------------
THINGIVERSE.COM LOGIN

<div class="login">
	<a href="/?redirect=YToyOntzOjQ6InR5cGUiO3M6ODoicmVkaXJlY3QiO3M6NDoiZGF0YSI7czoyNzoiaHR0cHM6Ly93d3cudGhpbmdpdmVyc2UuY29tIjt9"
       class="login-box login-options">
		<span class="login-join">
			Sign in / Join
		</span>
	</a>
</div>

$mech->form_name( 'form-login' );
$mech->set_fields(
    username => $username,
    password => $password,
);    
$mech -> submit();

<form id="sso-sign-in-form" method="post" onsubmit="return false;">
	<div class="error"><p></p></div>
	<div class="username-column">
		<label id="username-label" for="username">Username / Email Address</label>
		<input type="text" id="username" name="username">
		<div class="remember-me">
			<input type="checkbox" id="remember-me" name="remember-me">
			<label for="remember-me" class="quiet">Remember Me</label>
		</div>
	</div>
	<div class="password-column">
		<label id="password-label" for="username">Password</label>
		<input id="password" name="password" type="password">
		<div>
			<a id="forgot-password" href="/forgot?redirect=YToyOntzOjQ6InR5cGUiO3M6ODoicmVkaXJlY3QiO3M6NDoiZGF0YSI7czoyNzoiaHR0cHM6Ly93d3cudGhpbmdpdmVyc2UuY29tIjt9">
				Click here to reset your password.
			</a>
		</div>
	</div>
	<input type="hidden" id="sso-theme" name="theme" value="">
	<input type="hidden" id="sso-redirect" name="redirect" value="YToyOntzOjQ6InR5cGUiO3M6ODoicmVkaXJlY3QiO3M6NDoiZGF0YSI7czoyNzoiaHR0cHM6Ly93d3cudGhpbmdpdmVyc2UuY29tIjt9">
	<input type="submit" value="SIGN IN" id="sso_sign_in">
</form>
