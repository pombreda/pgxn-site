package PGXN::Site::Templates;

use 5.12.0;
use utf8;
use parent 'Template::Declare';
use PGXN::Site::Locale;
use Template::Declare::Tags;
use Software::License::PostgreSQL;
use Software::License::BSD;
use Software::License::MIT;
use List::Util qw(first);
use namespace::autoclean;
use SemVer;

my $l = PGXN::Site::Locale->get_handle('en');
sub T { $l->maketext(@_) }

BEGIN { create_wrapper wrapper => sub {
    my ($code, $req, $args) = @_;
    $l = PGXN::Site::Locale->accept($req->env->{HTTP_ACCEPT_LANGUAGE});
    outs_raw '<!DOCTYPE html>';
    html {
        attr {
            xmlns      => 'http://www.w3.org/1999/xhtml',
            'xml:lang' => 'en',
            lang       => 'en',
        };
        outs_raw( "\n", join "\n",
            '<!--',
            '____________________________________________________________',
            '|                                                            |',
            '|    DESIGN + Pat Heard { http://fullahead.org }             |',
            '|      DATE + 2006.03.19                                     |',
            '| COPYRIGHT + Free use if this notice is left in place       |',
            '|____________________________________________________________|',
            '-->'
        );

        head {
            title { $args->{title} };
            meta {
                name is 'keywords';
                content is 'PostgreSQL, extensions, PGXN, PostgreSQL Extension Network';
            };
            meta {
                name is 'description';
                content is 'Search all indexed extensions, distributions, '
                         . 'users, and tags on the PostgreSQL Extension Network.';
            };
            for my $spec (
                [ html   => 'screen, projection, tv' ],
                [ layout => 'screen, projection, tv' ],
                [ print  => 'print'                  ],
            ) {
                link {
                    rel   is 'stylesheet';
                    type  is 'text/css';
                    href  is "/ui/css/$spec->[0].css";
                    media is $spec->[1];
                };
            }
        }; # /head

        body {
            # HEADER: Holds title, subtitle and header images -->
            div {
                id is 'all';
                div {
                    id is 'header';
                    div {
                        id is 'title';
                        h1 { 'PGXN' };
                        h2 { T 'PostgreSQL Extension Network' };
                    };
                    a {
                        href is '/';
                        rel is 'home';
                        img {
                            src   is '/ui/img/gear.png';
                            alt   is T 'PGXN Gear';
                            class is 'gear';
                        };
                        img {
                            src   is '/ui/img/pgxn.png';
                            alt   is T 'PostgreSQL Extension Network';
                            class is 'right';
                        };
                    };
                }; # /div#header
                # CONTENT: Holds all site content except for the footer. This
                # is what causes the footer to stick to the bottom
                div {
                    id is 'content';
                    # MAIN MENU: Top horizontal menu of the site. Use
                    # class="here" to turn the current page tab on.
                    div {
                        id is 'mainMenu';
                        if (my $crumb = $args->{crumb}) {
                            ul {
                                id is 'crumb';
                                class is 'floatLeft';
                                $crumb->();
                            }
                        }
                        ul {
                            class is 'floatRight';
                            # XXX Fill in these links.
                            for my $spec (
                                [ '#', 'About PGXN',                 'About'  ],
                                # [ '#', 'Recent Uploads',             'Recent' ],
                                [ '#', 'News',                       'News'   ],
                                [ '#', 'Frequently Asked Questions', 'FAQ'    ],
                            ) {
                                li {
                                    a {
                                        href is $spec->[0];
                                        title is T $spec->[1];
                                        T $spec->[2];
                                    };
                                };
                            }
                        };
                    }; # /div#mainMenu

                    # Content goes here!
                    $code->();

                }; # /div#content
            }; # /div#all

            # FOOTER: Site footer for links, copyright, etc.
            div {
                id is 'footer';
                div {
                    id is 'width';
                    span {
                        class is 'floatLeft';
                        outs 'code';
                        a {
                            href is 'http://www.justatheory.com/';
                            title is T 'Go to [_1]', 'Just a Theory';
                            'theory';
                        };
                        span { class is 'grey'; '|' };
                        outs ' design';
                        a {
                            href is 'http://fullahead.org/';
                            title is T 'Go to [_1]', 'Fullahead';
                            'Fullahead';
                        };
                        span { class is 'grey'; '|' };
                        outs ' logo';
                        a {
                            href is 'http://www.strongrrl.com/';
                            title is T 'Go to [_1]', 'Strongrrl';
                            'Strongrrl';
                        };
                    }; # /span.floatLeft
                    span {
                        class is 'floatRight';
                        a {
                            href is '#'; # XXX
                            title is T 'Feedback';
                            T 'Feedback';
                        };
                    }; # /span.floatRight
                }; # /div#width
            }; # /div#footer
        }; # /body
    }; # /html
}; }


template home => sub {
    my ($self, $req, $args) = @_;
    wrapper {
        div {
            id is 'homepage';
            div {
                class is 'hsearch floatLeft';
                show search_form => { id => 'homesearch', in => 'doc' };

                div {
                    id is 'cloud';
                    # XXX Put tag cloud here.
                };
            }; # /div.hsearch floatLeft

            # 25 percent width column, aligned to the right.
            div {
                class is 'hside floatLeft gradient';
                p { T 'pgxn_summary_paragraph' };

                h3 { T 'Founders' };
                div {
                    id is 'founders';
                    a {
                        href is 'http://www.myyearbook.com/';
                        title is 'myYearbook';
                        img {
                            src is '/ui/img/myyearbook.png';
                            alt is 'myYearbook.com';
                        };
                    };
                    a {
                        href is 'http://www.pgexperts.com/';
                        title is 'PostgreSQL Experts, Inc.';
                        img {
                            src is '/ui/img/pgexperts.png';
                            alt is 'PGX';
                        };
                    };
                    a {
                        href is 'http://www.dalibo.org/en/';
                        title is 'Dalibo';
                        img {
                            src is '/ui/img/dalibo.png';
                            alt is 'Dalibo';
                        };
                    };
                }; # /div#founders

                h3 { T 'Patrons' };
                div {
                    id is 'patrons';
                    h3 {
                        a {
                            href is 'http://www.enovafinancial.com/';
                            title is 'Enova Financial';
                            img {
                                src is '/ui/img/enova.png';
                                alt is 'e';
                            };
                            outs ' Enova Financial';
                        };
                    };
                }; # /div#patrons

                h3 { T 'Benefactors' };
                ul {
                    id is 'benefactors';
                    for my $spec (
                        [ 'http://www.etsy.com/'          => 'Etsy'                      ],
                        [ 'http://www.postgresql.us/'     => 'US PostgreSQL Association' ],
                        [ 'http://www.commandprompt.com/' => 'Command Prompt, Inc.'      ],
                        [ 'http://www.marchex.com/'       => 'Marchex'                   ],
                    ) {
                        li { a { href is $spec->[0]; $spec->[1] } };
                    }
                }; # /ul
            }; # /div.hside floatLeft gradient

        }; # /div#homepage
    } $req, { title => T 'hometitle' };
};

sub _title_with($) {
    shift . ' / ' . T 'PostgreSQL Extension Network';
}

template distribution => sub {
    my ($self, $req, $args) = @_;
    my $dist = $args->{dist};
    wrapper {
        div {
            id is 'page';
            class is 'dist';
            div {
                class is 'gradient meta';
                h1 { $args->{dist_name} };
                span {
                    class is 'download';
                    a {
                        class is 'url';
                        href is URI->new($args->{api_url} . $dist->download_path);
                        title is T 'Download [_1] [_2]', $dist->name, $dist->version;
                        img {
                            src is '/ui/img/download.png';
                            alt is T 'Download';
                        };
                    };
                }; # /span.download
                span {
                    class is 'browse';
                    a {
                        class is 'url';
                        href is URI->new($args->{api_url} . $dist->source_path);
                        title is T 'Browse [_1] [_2]', $dist->name, $dist->version;
                        img {
                            src is '/ui/img/package.png';
                            alt is T 'Browse';
                        };
                    };
                }; # /span.download
                dl {
                    dt { T 'This Release' };
                    dd {
                        span { class is 'fn';      $dist->name };
                        span { class is 'version'; $dist->version };
                    };
                    dt { T 'Date' };
                    dd {
                        my $datetime = $dist->date;
                        (my $date = $datetime) =~ s{T.+}{};
                        # Looking forward to HTML 5 in Template::Declare.
                        outs_raw qq{<time class="bday" datetime="$datetime">$date</time>};
                    };
                    dt { T 'Status' };
                    dd { T $dist->release_status };
                    my $rel = $dist->releases;
                    my @rels = @{ $rel->{stable} || [] };
                    if (my @others = (@{ $rel->{testing}  || [] }, @{ $rel->{unstable} || [] })) {
                        @rels =
                            map  { $_->[0] }
                            sort { $b->[1] <=> $a->[1] }
                            map  { [ $_ => SemVer->new($_->{version}) ] } @rels, @others;
                    }
                    if (@rels > 1) {
                        # Show latest version for other statuses.
                        for my $status (qw(Stable Testing Unstable)) {
                            my $stat_version = $dist->version_for(lc $status) or next;
                            if ($dist->version ne $stat_version) {
                                dt { T "Latest $status" };
                                dd {
                                    my $datetime = $dist->date_for(lc $status);
                                    (my $date = $datetime) =~ s{T.+}{};
                                    a {
                                        href is '/dist/' . $dist->name . "/$stat_version/";
                                        outs $dist->name . " $stat_version — ";
                                        outs_raw qq{<time datetime="$datetime">$date</time>};
                                    }
                                };
                            }
                        }
                        # Create a select list of all other versions.
                        dt { T 'Other Releases' };
                        dd {
                            select {
                                onchange is 'window.location.href = this.options[this.selectedIndex].value';
                                my $version = $dist->version;
                                for my $rel (@rels) {
                                    # Include release status in the option name?
                                    option {
                                        value is '/dist/' . $dist->name . "/$rel->{version}/";
                                        selected is 'selected' if $rel->{version} eq $version;
                                        (my $date = $rel->{date}) =~ s{T.+}{};
                                        $dist->name . " $rel->{version} — $date";
                                    };
                                }
                            };
                        };
                    }
                    dt { T 'Abstract' };
                    dd { class is 'abstract'; $dist->abstract };
                    if (my $descr = $dist->description) {
                        dt { T 'Description' };
                        dd { class is 'description'; $descr };
                    }
                    dt { T 'Released By' };
                    dd {
                        span { class is 'vcard'; a {
                            class is 'url fn';
                            href is '/user/' . $dist->user;
                            $dist->user;
                        }};
                    };
                    dt { T 'License' };
                    dd {
                        if (ref $dist->license eq 'HASH') {
                            my $licenses = $dist->license;
                            for my $license (sort keys %{ $licenses }) {
                                a {
                                    rel is 'license';
                                    href is $licenses->{$license};
                                    $license;
                                };
                            }
                        } else {
                            for my $l (ref $dist->license ? @{ $dist->license } : ($dist->license)) {
                                if (my $license = _license($l)) {
                                    a {
                                        rel is 'license';
                                        href is $license->url;
                                        $license->name;
                                    };
                                } else {
                                    my %other_strings = (
                                        map { $_ => 1 } qw(open_source restricted unrestricted)
                                    );
                                    outs $other_strings{$l} ? $l : 'unknonwn';
                                }
                            }
                            for my $license (grep {
                                defined
                            } map {
                                _license($_)
                            } ref $dist->license ? @{ $dist->license } : ($dist->license)) {
                            }
                        }
                    };
                    my $res = $dist->resources;
                    if (%{ $res }) {
                        dt { T 'Resources' };
                        my @res;
                        if (my $url = $res->{homepage}) {
                            push @res => [ 'url', $url, T 'www' ];
                        }
                        if (my $repo = $res->{repository}) {
                            if (my $url = $repo->{url}) {
                                push @res => [ 'url', $url, $repo->{type} ];
                            }
                            if (my $url = $repo->{web}) {
                                # XXX Think of a better name than "repo"?
                                push @res => [ 'url', $url, T 'repo' ];
                            }
                        }
                        if (my $bug = $res->{bugtracker}) {
                            if (my $url = $bug->{web}) {
                                push @res => [ 'url', $url, T 'bugs' ]
                            }

                            if (my $email = $bug->{mailto}) {
                                push @res => [ 'email', "mailto:$email", $email ]
                            }
                        }
                        dd {
                            class is 'resources';
                            ul {
                                my $last = pop @res;
                                for my $spec (@res) {
                                    li {
                                        a {
                                            class is $spec->[0];
                                            href is $spec->[1];
                                            $spec->[2];
                                        };
                                    };
                                }
                                li {
                                    class is 'last';
                                    a {
                                        class is $last->[0];
                                        href is $last->[1];
                                        $last->[2];
                                    };
                                };
                            };
                        };
                    }
                    if (my @files = $dist->special_files) {
                        dt { T 'Special Files' };
                        dd {
                            class is 'files';
                            ul {
                                my $uri = $args->{api_url} . $dist->source_path;
                                for my $file (@files) {
                                    li {
                                        class is 'last' if $file eq $files[-1];
                                        a {
                                            href is URI->new("$uri$file");
                                            $file;
                                        };
                                    };
                                }
                            }
                        };
                    }
                    if (my @tags = $dist->tags) {
                        dt { T 'Tags' };
                        dd {
                            class is 'tags';
                            ul {
                                my $last = pop @tags;
                                for my $tag (@tags) {
                                    li { a {
                                        href is URI->new("/tag/$tag/");
                                        $tag;
                                    } };
                                }
                                li {
                                    class is 'last';
                                    a {
                                        href is URI->new("/tag/$last/");
                                        $last;
                                    };
                                };
                            };
                        };
                    }
                }; # /dl
            }; # /div.gradient meta

            my $docs = $dist->docs;
            my $sep = $req->uri =~ m{/$} ? '' : '/';
            div {
                class is 'gradient exts';
                h3 { T 'Extensions' };
                dl {
                    my $provides = $dist->provides;
                    for my $ext (sort { $a cmp $b } keys %{ $provides }) {
                        my $info = $provides->{$ext};
                        my $path = $info->{doc};
                        dt {
                            if ($path) {
                                delete $docs->{$path};
                                a {
                                    href is $req->uri . "$sep$path.html";
                                    span { class is 'fn';       $ext             };
                                    span { class is 'version';  $info->{version} };
                                };
                            } else {
                                span { class is 'fn';       $ext             };
                                span { class is 'version';  $info->{version} };
                            }
                        };
                        dd { class is 'abstract'; $info->{abstract} };
                    }
                } # /dl
            }; # /div.gradient exts

            my $has_readme = delete $docs->{README};

            if (%{ $docs }) {
                div {
                    class is 'gradient docs';
                    h3 { T 'Documentation' };
                    dl {
                        while (my ($path, $info) = each %{ $docs }) {
                            dt {
                                class is 'doc';
                                a {
                                    href is $req->uri . "$sep$path.html";
                                    span {
                                        class is 'fn';
                                        if ($info->{abstract}) {
                                            outs $info->{title}
                                        } else {
                                            (my $page = $path) =~ s{^docs?/}{};
                                            outs $page;
                                        }
                                    };
                                };
                            };
                            dd { class is 'abstract'; $info->{abstract} || $info->{title} };
                        }
                    };
                };
            }

            if ($has_readme) {
                my $body = $dist->body_for_doc('README');
                utf8::decode $body;
                div {
                    class is 'gradient exts readme';
                    h3 { T 'README' };
                    outs_raw $body;
                };
            }
        }; # /div#page
    } $req, {
        title => _title_with $args->{dist_name} . ': ' . $dist->abstract,
        crumb => sub {
            li { a {
                href is '/user/' . $dist->user;
                title is $dist->user;
                $dist->user;
            } };
            li {
                class is 'sub';
                a {
                    href is $req->uri;
                    title is $args->{dist_name};
                    $args->{dist_name};
                }
            };
        },
    };
};


template document => sub {
    my ($self, $req, $args) = @_;
    my $dist = $args->{dist};
    my $info = $dist->docs->{$args->{doc}};
    my $title = $info->{abstract} ? $info->{title} : do {
        (my $page = $args->{path}) =~ s{^docs?/}{};
        $page;
    };

    wrapper {
        div {
            id is 'page';
            class is 'doc';
            outs_raw $args->{body};
        }; # /div#page
    } $req, {
        title => _title_with $title . ($info->{abstract} ? ": $info->{abstract}" : ''),
        crumb => sub {
            li { a {
                href is '/user/' . $dist->user;
                title is $dist->user;
                $dist->user;
            } };
            li {
                class is 'sub';
                a {
                    href is $args->{dist_uri};
                    title is $args->{dist_name};
                    $args->{dist_name};
                }
            };
            li {
                class is 'sub here';
                a {
                    href is $req->uri;
                    title is $title;
                    $title;
                }
            };
        },
    };
};

template user => sub {
    my ($self, $req, $args) = @_;
    my $user = $args->{user};
    my $api  = $args->{api};

    wrapper {
        div {
            id is 'page';
            class is 'dist';
            div {
                class is 'gradient meta vcard';
                h1 { class is 'fn'; $user->name };
                dl {
                    dt { T 'Nickname' };
                    dd {a {
                        class is 'nickname';
                        href is '/user/' . $user->nickname;
                        $user->nickname;
                    } };
                    dt { T 'Email' };
                    dd {
                        class is 'email';
                        outs_raw '<a href="'
                            . _obscure('mailto:' . $user->email)
                            . '">' . _obscure($user->email)
                            . '</a>';
                    };
                    dt { T 'URL' };
                    dd {
                        class is 'url';
                        a { href is $user->uri; $user->uri; };
                    };
                    if (my $t = $user->twitter) {
                        dt { T 'Twitter' };
                        dd {
                            class is 'twitter';
                            a { href is "http://twitter.com/$t"; $t };
                        };
                    }
                };
            }; # /div.gradient meta vcard

            show release_table => $req, $user->releases, $args;
        }; # /div#page
    } $req, {
        title => _title_with $user->name . ' (' . $user->nickname . ')',
    };
};

template tag => sub {
    my ($self, $req, $args) = @_;
    my $tag = $args->{tag};
    my $api = $args->{api};
    my $title = T 'Tag: [_1]', $tag->name;

    wrapper {
        div {
            id is 'page';
            class is 'dist';
            h1 { $title };
            show release_table => $req, $tag->releases, $args;
        }; # /div#page
    } $req, {
        title => _title_with $title,
    };
};

template search => sub {
    my ($self, $req, $args) = @_;
    my $api  = $args->{api};
    my $res  = $args->{results};

    wrapper {
        div {
            id is 'page';
            div {
                id is 'results';
                class is 'gradient';

                if (my @hits = @{ $res->{hits} || [] }) {
                    h3 {
                        T '[_1]-[_2] of [_3] found',
                            $res->{offset} + 1,
                            $res->{offset} + @hits,
                            $res->{count};
                    };
                    show "results/$res->{index}" => @hits;
                    if (my $c = $res->{count}) {
                        my $uri = $req->uri;
                        my @params = (
                            in => $res->{index},
                            q  => $res->{query},
                            l  => $res->{limit},
                        );
                        div {
                            class is 'searchnav';
                            if ($res->{offset}) {
                                p {
                                    class is 'floatLeft';
                                    a {
                                        $uri->query_form(
                                            @params,
                                            o => $res->{offset} - $res->{limit}
                                        );
                                        href is $uri;
                                        title is T 'Previous results';
                                        T '← Prev';
                                    };
                                };
                            }
                            if ($c > $res->{offset} + $res->{limit}) {
                                p {
                                    class is 'floatRight';
                                    style is 'clear:right';
                                    a {
                                        $uri->query_form(
                                            @params,
                                            o => $res->{offset} + $res->{limit}
                                        );
                                        href is $uri;
                                        title is T 'Next results';
                                        T 'Next →';
                                    };
                                };
                            }
                        };
                    }
                } else {
                    h3 { T 'Search matched no documents.' }
                }
            }; # /div.gradient
        }; # div#page
    } $req, {
        title => $args->{results}{query} . ' / ' . T('PGXN Search'),
        crumb => sub {
            li {
                class is 'notmenu';
                show search_form => {
                    id    => 'resultsearch',
                    query => $res->{query},
                    in    => $res->{index},
                };
            }
        },
    };
};

template 'results/extension' => sub {
    $_[0] = 'extension';
    &_detailed_results;
};

template 'results/doc' => sub {
    $_[0] = 'title';
    &_detailed_results;
};

# template 'results/detailed' => sub {
sub _detailed_results {
    my $label = shift;
    for my $hit (@_) {
        div {
            class is 'res';
            h2 {
                if ($hit->{doc}) {
                    a {
                        href is "/dist/$hit->{dist}/$hit->{doc}.html";
                        $hit->{$label}
                    };
                } else {
                    $hit->{$label}
                }
            };
            p { outs_raw $hit->{excerpt} };
            ul {
                li {
                    class is 'dist';
                    a {
                        href is "/dist/$hit->{dist}/";
                        title is T 'In the [_1] distribution', $hit->{dist};
                        "$hit->{dist} $hit->{version}";
                    };
                };
                li {
                    class is 'date';
                    (my $date = $hit->{date}) =~ s{T.+}{};
                    # Looking forward to HTML 5 in Template::Declare.
                    outs_raw qq{<time class="bday" datetime="$hit->{date}">$date</time>};
                };
                li {
                    class is 'user';
                    a {
                        href is "/user/$hit->{user}/";
                        title is T 'Uploaded by [_1]', $hit->{user_name};
                        $hit->{user_name};
                    };
                };
            };
        };
    }
};

template 'results/dist' => sub {
    my $self = shift;
    for my $hit (@_) {
        div {
            class is 'res';
            h2 {
                a {
                    href is "/dist/$hit->{dist}";
                    $hit->{dist}
                };
            };
            p { outs_raw $hit->{excerpt} };
            ul {
                li {
                    class is 'date';
                    (my $date = $hit->{date}) =~ s{T.+}{};
                    # Looking forward to HTML 5 in Template::Declare.
                    outs_raw qq{<time class="bday" datetime="$hit->{date}">$date</time>};
                };
                li {
                    class is 'user';
                    a {
                        href is "/user/$hit->{user}/";
                        title is T 'Uploaded by [_1]', $hit->{user_name};
                        $hit->{user_name};
                    };
                };
            };
        }
    }
};

template 'results/tag' => sub {
    my $self = shift;
    for my $hit (@_) {
        div {
            class is 'res';
            h2 {
                a {
                    href is "/tag/$hit->{tag}";
                    $hit->{tag}
                };
            };
        }
    }
};

template 'results/user' => sub {
    my $self = shift;
    for my $hit (@_) {
        div {
            class is 'res';
            h2 {
                a {
                    href is "/user/$hit->{user}";
                    $hit->{user};
                };
            };
            p { outs_raw $hit->{name} };
        }
    }
};

template notfound => sub {
    my ($self, $req, $args) = @_;
    wrapper {
        h1 { T 'Not Found' };
        p {
            class is 'warning';
            T q{Resource not found.};
        };
    } $req, {
        title => _title_with T 'Resource Not Found',
    };
};

template servererror => sub {
    my ($self, $req, $args) = @_;
    wrapper {
        h1 { T 'Internal Server Error' };
        p {
            class is 'error';
            T q{Internal server error.};
        };
    } $req, {
        title => _title_with T 'Internal Server Error',
    };
};

template search_form => sub {
    my ($self, $args) = @_;
    form {
        id is $args->{id};
        action is '/search';
        enctype is 'application/x-www-form-urlencoded';
        method is 'get';
        fieldset {
            class is 'query';
            input {
                type  is 'text';
                class is 'width50';
                name  is 'q';
                value is $args->{query};
            };
        }; # /fieldset.query
        fieldset {
            class is 'submitin';
            label { attr { id is 'inlabel'; for => 'searchin' }; T 'in' };
            select {
                id is 'searchin';
                name is 'in';
                my $in = $args->{in};
                option {
                    value is 'doc';
                    selected is 'selected' if $in eq 'doc';
                    'Documentation';
                };
                for my $spec (
                    [ extension => 'Extensions'    ],
                    [ dist      => 'Distributions' ],
                    [ user      => 'Users'         ],
                    [ tag       => 'Tags'          ]
                ) {
                    option {
                        value is $spec->[0];
                        selected is 'selected' if $in eq $spec->[0];
                        T $spec->[1];
                    };
                }
            };
            input {
                type  is 'submit';
                value is T 'PGXN Search';
                class is 'button';
            };
        }; # /fieldset.submitin
    }; # /form#resultsearch
};

template release_table => sub {
    my ($self, $req, $rel, $args) = @_;
    my $api = $args->{api};
    div {
        class is 'gradient dists';
        h3 { T 'Distributions' };
        table { tbody {
            for my $dist (sort keys %{ $rel }) {
                my $status = first { $rel->{$dist}{$_} } qw(stable testing unstable);
                my $info   = $rel->{$dist}{$status}[0];
                row {
                    class is 'dist';
                    cell {
                        class is 'name';
                        a {
                            class is 'url';
                            href is "/dist/$dist/";
                            span { class is 'fn'; $dist };
                            span { class is 'version'; $info->{version} };
                            span { class is 'status'; "($status)" } if $status ne 'stable';
                        };
                    };
                    cell {
                        class is 'abstract';
                        $rel->{$dist}{abstract};
                    };
                    cell {
                        class is 'bday';
                        (my $date = $info->{date}) =~ s{T.+}{};
                        # Looking forward to HTML 5 in Template::Declare.
                        outs_raw qq{<time class="bday" datetime="$info->{date}">$date</time>};
                    };
                    cell {
                        class is 'download';
                        a {
                            class is 'url';
                            href is URI->new($args->{api_url} . $api->download_path_for($dist => $info->{version}));
                            title is T 'Download [_1] [_2]', $dist, $info->{version};
                            img {
                                src is '/ui/img/download.png';
                                alt is T 'Download';
                            };
                        };
                    };
                    cell {
                        class is 'browse';
                        a {
                            class is 'url';
                            href is URI->new($args->{api_url} . $api->source_path_for($dist => $info->{version}));
                            title is T 'Browse [_1] [_2]', $dist, $info->{version};
                            img {
                                src is '/ui/img/package.png';
                                alt is T 'Browse';
                            };
                        }
                    };
                }; # /tr.dist
            }
        } }; # /table
    }; # /div.gradient dists
};

my %class_for = (
    agpl_3       => 'AGPL_3',
    apache_1_1   => 'Apache_1_1',
    apache_2_0   => 'Apache_2_0',
    artistic_1   => 'Artistic_1_0',
    artistic_2   => 'Artistic_2_0',
    bsd          => 'BSD',
    freebsd      => 'FreeBSD',
    gfdl_1_2     => 'GFDL_1_2',
    gfdl_1_3     => undef,
    gpl_1        => 'GPL_1',
    gpl_2        => 'GPL_2',
    gpl_3        => 'GPL_3',
    lgpl_2_1     => 'LGPL_2_1',
    lgpl_3_0     => 'LGPL_3_0',
    mit          => 'MIT',
    mozilla_1_0  => 'Mozilla_1_0',
    mozilla_1_1  => 'Mozilla_1_1',
    openssl      => 'OpenSSL',
    perl_5       => 'Perl_5',
    postgresql   => 'PostgreSQL',
    qpl_1_0      => 'QPL_1_0',
    ssleay       => 'SSLeay',
    sun          => 'Sun',
    zlib         => 'Zlib',
);

sub _license($) {
    my $class = $class_for{+shift} or return;
    $class = "Software::License::$class";
    eval "require $class; 1" or die;
    return $class;
}

sub _obscure ($) {
#
#   Input: an email address, e.g. "foo@example.com"
#
#   Output: the email address as a mailto link, with each character
#       of the address encoded as either a decimal or hex entity, in
#       the hopes of foiling most address harvesting spam bots. E.g.:
#
#     <a href="&#x6D;&#97;&#105;&#108;&#x74;&#111;:&#102;&#111;&#111;&#64;&#101;
#       x&#x61;&#109;&#x70;&#108;&#x65;&#x2E;&#99;&#111;&#109;">&#102;&#111;&#111;
#       &#64;&#101;x&#x61;&#109;&#x70;&#108;&#x65;&#x2E;&#99;&#111;&#109;</a>
#
#   Based on a filter by Matthew Wickline, posted to the BBEdit-Talk
#   mailing list: <http://tinyurl.com/yu7ue>
#
    my $addr = shift;

    my @encode = (
        sub { '&#' .                 ord(shift)   . ';' },
        sub { '&#x' . sprintf( "%X", ord(shift) ) . ';' },
        sub {                            shift          },
    );

    $addr =~ s{(.)}{
        my $char = $1;
        if ( $char eq '@' ) {
            # this *must* be encoded. I insist.
            $char = $encode[int rand 1]->($char);
        }
        elsif ( $char ne ':' ) {
            # leave ':' alone (to spot mailto: later)
            my $r = rand;
            # roughly 10% raw, 45% hex, 45% dec
            $char = (
                $r > .9   ?  $encode[2]->($char)  :
                $r < .45  ?  $encode[1]->($char)  :
                             $encode[0]->($char)
            );
        }
        $char;
    }gex;

    return $addr;
}

=head1 Name

PGXN::Site::Templates - HTML templates for PGXN::Site

=head1 Synopsis

  use PGXN::Site::Templates;
  Template::Declare->init( dispatch_to => ['PGXN::Site::Templates'] );
  print Template::Declare->show('home', $req, {
      title   => 'PGXN::Site',
  });

=head1 Description

This class defines the HTML templates used by PGXN::Site. They are used
internally by L<PGXN::Site::Controller> to render the UI. They're implemented
with L<Template::Declare>, but interface wise, all you need to do is C<show>
them as in the L</Synopsis>.

=head1 Templates

=head2 Wrapper

=head3 C<wrapper>

Wrapper template called by all page view templates that wraps them in the
basic structure of the site (logo, navigation, footer, etc.). It also handles
the title of the site, and any status message or error message. These must be
stored under the C<title>, C<status_msg>, and C<error_msg> keys in the args
hash, respectively.

=begin comment

XXX Document all parameters.

=end comment

=head2 Full Page Templates

=head3 C<home>

Renders the home page of the app.

=head2 Utility Functions

=head3 C<T>

  h1 { T 'Welcome!' };

Translates the string using L<PGXN::Site::Locale>.

=head1 Author

David E. Wheeler <david.wheeler@pgexperts.com>

=head1 Copyright and License

Copyright (c) 2011 David E. Wheeler.

This module is free software; you can redistribute it and/or modify it under
the L<PostgreSQL License|http://www.opensource.org/licenses/postgresql>.

Permission to use, copy, modify, and distribute this software and its
documentation for any purpose, without fee, and without a written agreement is
hereby granted, provided that the above copyright notice and this paragraph
and the following two paragraphs appear in all copies.

In no event shall David E. Wheeler be liable to any party for direct,
indirect, special, incidental, or consequential damages, including lost
profits, arising out of the use of this software and its documentation, even
if David E. Wheeler has been advised of the possibility of such damage.

David E. Wheeler specifically disclaims any warranties, including, but not
limited to, the implied warranties of merchantability and fitness for a
particular purpose. The software provided hereunder is on an "as is" basis,
and David E. Wheeler has no obligations to provide maintenance, support,
updates, enhancements, or modifications.

=cut
