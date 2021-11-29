export ZTTY_FEATURES="Cat:${ZTTY_FEATURES}"
# 2020-02-24: catコマンドを拡張子別に変更
function cat(){
    # ヒアドキュメント判定
    if test "`echo $@ | grep 'EOF' | grep '<<' `"  -eq 0
    then
        /bin/cat $@
        return
    else
        # 複数ファイルを判定しない
        if [ $# -eq 1 ];
        then
            # PlainTextなファイル
            if [ "`file $1 | grep 'text'`" ];
            then
                # 拡張子別に振り分け
                case "$1" in
                    *.csv ) column -ts, $1 | nl ;;
                    *.md  ) mdcat $1 | nl ;;
                    *     ) /bin/cat $1 | nl ;;
                esac
            else
                /bin/cat $1 | nl
            fi
        else
            /bin/cat  $@ | nl
        fi
    fi
}

