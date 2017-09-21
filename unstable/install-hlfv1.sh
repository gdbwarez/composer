ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.13.0
docker tag hyperledger/composer-playground:0.13.0 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� h�Y �=�r�Hv��d3A�IJ��&��;ckl� 	�����*Z"%^$Y���&�$!�hR��[�����7�y�w���^ċdI�̘�A"�O�έ�U���Pp��-���0�c��~[t? ��$�?��)D$!�H��1!&F#��#A�E��# �S���lh��6aW���-{�+�.2-��Y��Y��j
��9 �'�m�~3l���`�6�����Z6HY��A���2C��c,�P;ش-�$ �lK���g�]��F�)uP8<�d�R�l>�~� p���+�T-~��,����UhC�2�aySB�ė�2�"�	��"d�j[3��ab]�� �D6�X<�U2�E�H%��4��ݤ1Մ��tw.���O�i�7��d�M\�t�x�oښz�LMY4|Y��ulwA����,��bPXD�&U�ֺ�"��C�bc�ᇚ��|6}�&���UԠn-lWk#��e��<l��$,�t��ϨO�1u����Q�C!�r]�vGGt�q!*�_v
��L�`��V���D��j[�|��90b�r�WY,��Ӷ;d�
bBwz��2����n�l0�tO�k�������2S��̑.bw�&�f�)��'���ʘ�m���kx��g ����+*�CG�����i@}hK&m����V�󁫁*���'|��6���G��|�/%�D�G z�=�_��7c�mD�(�3\���wm��t����0]�hD
�E��\
����*��w��f�j�jrvL��s��쟪�Tc��WI����rpTNe�
�<����߃NO%�Bt��A��֥�F�!�T��r~V�_��Wk���a��w�҂<��q/m��?i����S�[���t�����6�c'b��Q�t�h�d�
+����Y�9�ul��Z�Cň�i٠�tg��1�.�i�l�A��D�fc���'<��6���В'M�F7���g�6ƺ��9oS�C�nbs��)��p��k
2,ֶL���a�,�&��:���c{Yӱ�R��?��-�;tB-ڑ��4w�AvÊ������o���h����Ժ�o8z�=�A��C����h�d!���.J�O�`"8<O`��ƥ�>���>"�=IL=�!5�� j��&��������i�v�.��/L�N��� 
�Z����?�	�^�;;�vڠ��:��
L��]D
0�Ќ�襐���,w�orWw(�<}�2>nrZ����H<��v σ��(I���41��H{�6$�^o����� D6�z-�~2�\]#��'�㭇�^��6�f�6`A�N��Y����g��%� �@���(l�G�������w�-�F{<�a�@��c:hW����ߙ���9�YV����>n�U��aC�	�_=<}s�	�.}:ܱ"u8z�\��+9��*Ѿ��|��M2Q.wX����:�ґb�^SS� 3��x��h�<g�	�l���:yo�y���y����l��?���+�	��*m�)�񏲧�d��
���`�ի�T�>�;5��W`]#x�B��rdA�S����K���2ҽ��P���O,���>���a������X"���O˿�>�]�~Rzt�zg��;�!��>��Qw��:�Qo7g�9�I)�A�l��t���	ꄫ��+*�r����3�Mȫ&�?{�]��<{z5�<xF�Ĝ��%�r�r��O}8Δ+��⋋��m���	�Y�1,d�$N��in�����k`�U�!�B�i�t+����#�Y�S���JU.W?T���Qu~�'�f�]���"��Z�׆0Q{G��c�~��v���H��E�~޾Og6��g��D��{�oI�s9��۠H\q�]C&~�>����@�u�,��N x�J���߀y*�;.��lAP�I.�#6C�+d�`��N΋軋5����k�o5����l�����}��e��i�/���p���=�T���i� �� 蘨�]��'��z�}�u�3��_�{��ߋ����:�s�|���N\p���o������%(x����L��^\������݅c���M��4��tLͰ���64T+��x u��G6}���N�'�D�\N����0�h����(���D�l������}��%=��O��e�6�AF���!ω�/2�N?��W��[� P�*��c�Τ37B�]��{��c�4H�F��f�y������Bl�	��=�<�1�a�!]�`����a�u��;g�����8]���,`�Pt����[������/��qi��'���Z�?<�]��
�H��
���ㅈذ��R��GgD�з�^r�p Z{<��xz�q�����2|�
[AF�6�뻷j;JS�MTY��7���,������p4�����/��[�#�b�Z�i���	�?1���zh��G��*�T���Rhi�olZ��xd�����?���6�!�ݙ�>�Rp��� �f>c�f#� µ[�� ЙG�S:3 E έD;�$	@?xC�����Bt��2Y��gm�]���ҌgK����ʽdFY#�~��-�M2�%��x�;�StLԑ��`2���L^�6�R�̜1��t��Y�1&*���T"��W���`a���S��J�3�G��a/Jf�ե!��&��)D�Ǒ�V2��{5c(�
���Í��P�}B�?��ai}��
����������Ų6�/��+D���?Ѩ���\	p��5��{���������������a������E���"*����Z]R��X��K�8D������%"��D4�k�h���n����_��	o���������_�#��m|��5o��}�q)lXش5������m-ب����j�/_M�����jD��߳\w�ƿl��7���������Dp���$�W�����c���~�8N�h�1�`����f}��+����y��j���?"���j���O7y�6�������bBd��WW�k<�(�jh*)�w�,��&�K���A�n��<���t��߾�-�A���l�c�	�(J����ߊ[���+RmKIH�"<�R��D$A��V&jb���h�4��Ԯx�Z�V�'@!��� �)W��|J�fX�;��ϧr穔��r/����\t��⋾J���M\Ù�^���=|��<2��\f�	���ţL�YH.2�r9�(R�T�ج��v-�ځ'���|�>S��c�LK��J;뜆�����E�*�q1p5�K��.3�ٛf��&i�U�絰p�����S�f���;c�=���T����+��Åj^8���'�윕	òw��y�V(Y�T�4}\*�2���G��j�L]*Y�+��<9�*�h級9)$K��/
�w�Q8��3g�ӓ�9|S<�]fꅤ�0�^�tR��IT&sa*Q岶������n��<#3�,����JAJȍL.��>�2�����9gk�"Ys��J�p������t��<j��dN����]c�ur��G�S�'�e�ZѴh!~?���[�J<o��r�L��s���y���/�Y�[5��$C�]��FZ.й�-�r}+#��r!e�Q��^�UH���d�<�N<�O&�fy���k촉����)����~�%\�d쏌�`Jr!s�ʗR��W��3R���Z�I[�2=I���ًx:E��w���P#ߨD�b�]|�Wqg:0��q���xs\�=���OI�xW-��wc�L1=C��`C?�c�����1c����������}A�� ���������o��_)|�������>�{�kX��/��G���DD1���[	��I���11`/s�Js�|n��dy��N��>T���|o?���PBk�b����X��oP1w��]=�F�ey�d��&q�R�\6�)�tT,w
G��,L�_\K픎_�P�1'����r���(zt��i�T��8�ة�Q*r(}���ӻU�Q��ą�cη|���g����/]��ѵ�_|6���>�����a�ó��:��J`��%��q�m�2��]��#%�����\Rҥ����ɦ�`5��pq�pB��^7:�y���Y��� �)��q���DcwĽ��֥m�mC>���ֻ��Q�ô���7��=�ܳ�ہO��~��4���5�}x�_	["�����Qi��q5��p�o���|�@��� �u�i�ʈ���(��������6����5dn�Q�[�G���F ���Fu��X��Ө.hh��@�mh��~�E-����}vi�?��e�8��5� ���~g� i܆����X�}�M)�R�*V���EPC:�$�jtd#0�`��zú2�1�]l��/y�s��<�F�={�P���y��N�>4�>�#���8Z��2��d�k�{u]�xͦ?v5�B42����>vL��k���U����-У{�`��H�"2}�F/]it)xtذ�@h h��O���_��!���0*�Ӷ-�v���=���UOޞLI ��裣���&�6���/lP�%��ay�^���Ȝa���Le@}���(����&��g���TDU�Oph�T��/����Kwu�I��3�����p��A�|s9y0��r����>��.�2���۬3t�>izIj%"B^�/���e�.���c�1m;��u�I��vE���̉�u�2��7���ql�8\\�o*@ [JY1X#83�T���ˇS.C	|8�B\;�݋�T "�66��JإH�C�-F�"���G�1�e x]Jt�[��Bn�����[K��'���C�;�1~��\�^���h�%�Y�͗��n���e�6Tt�W��M��7L_����U��l�Ql�>���5�N�`��u#�v�*C:14�t۱:!D�(�c)"�b86�԰���y*��dM[������;:��kh".�htB�
�*�ݞ��c�W��k�G:��ꄎ�m��\�Ӿ�~�Hd�v;d�|�1O�i0 ß_|0q:�Xn���Au�C�mPQ�3| ��*����X����wj��l�?=���b�� ���m,���RD�������g�Zb��rwO�\�MO��~P0C�f�Q_��H�$�)���I���<Y\9��8q7v�$T,���H�b��`�،@�� ,b�����q�U�5�Vߺ�>����w�����KB?
��_R?����濔��ۓ����O�?W���|����o���~G>Ǒ���������譣A�����5t1�ʟ~�Bѐ�H��*�X�
G�r�)IaM<#íA*dT�	�lK�!��_H�x���~��|���~��W~����������8�{�],�;X���G�^�h��߼���� ���~/��� ����"_J���?|�0����v�m����n��b�S.Z�����n4Z>6�t,��z�l2,}�t:��~/�/X��,�
�-��W!>tUC`Zv�P؍��Z3�XsA��ٝ�V&6�.iB���B�@
��d=[��
�3DH	���N���HkQ(
&g���1[��ǍAl�h]�X74|��L\�����ns����L(�̈́	3�rs�k�T��*n6��i��B�4���E�y�W/��3^����3l��׏��iz���y͠:� S<���S|id�|�k��t"�.T���~�.�쬄��3%Y,SVF�+e�B3Y��"��)�����$����5?]O"L�A��	3�v�I�ْC�Y!��B')�yD�:)��"}.��F�4��05+��"S����yx���*�4߉/&=T+��.q�@汨F.��L��w��.����43���dMk�IJ�UKe�H'�Qz6nRbnn�'��X9�����������\�Mw�^"w�^"wE^"w^"w�]"w�]"wE]"w]"w�\"w�\"wE\"� ��0�.�f)E���O�J�㕌Rb��9��7��x1���8��60�.��q/jgE�s�*'�K螻�<R�[��۩����@���������A\�S붗yj:Ċ�Hz�3D渁gC�iT�r���f	~����ܔ	�jiZ=G0��S�DY
7��&��	N���Hj��j�����&�'����8c+s�ٲ�#t-��Itoi⭈�Sf�[87/T?:5�r82�1J�a�C�9�)�fbX�vb��(N��<]�D��eS}BᒹӊJ��ܤ�Gd��J�~�̢Ԁ��˼[�w��ہ_8z=�A�(���G�=z��r�?� ���u���n�}���o���&���G��Z>	�s������G�N>��^�:5]���/z�����x#�ׁ�����[�(������+��o<�S�|�㇁<|���<��+EYfi�2YZ�|ވ�r��2y���r�b��ۭ-�/�/Z�'X����8���-3a�3I��Pr!���Ky������\�-�
&�qD�ilJ����]	���o� �D����tZ�������x�BH5J����Ȕ�S�cv�W������T��ln���z�X`��z�mQt|�TZ�8i�F�֣��6H�;*?NWFx�Dj"���L�x����+�4k9M�S���4K��� #�@��P!iAf;��3R�[T�F;*]n'���HĐ��sK�l=Qu�4_�/�SdMQv�)�e8Z�՚���k�&.v˃A�D�	�k9˂�`d-�~�l!���9m�����]f�tÚrܘ3U���-^�J�d�G����ǿu%�ā����B=��|yP�����δ[\n�����e��]���4�K���� �u�#�q��"��"��Y���j#�o?c�gf��e\vGn��.�#����u�{����7�ڴ���
G�[�e:��Ɇ�Vyc֑�|&Oԓ�8�Vla8,)�zܯ���X�.}6�0Ōb4��í��y���è���F��J��lV��*\�ڴe�6��M��6���x��Gt�:��Sȇ�N"5�u���8R힟Z{:��A�|�W:�dZ�R�%��b��҂4=mբy%٨(�T�/��1�.Efi�	�ys �7.5/E�a:��&S�v?�Ry.B�[Åip�X�1#�x�E��³��u%OdE�H+E"dg��xXS#S�1�+��-��l��U$#3I;�d�p�G����4�2An{�*de_�L$k;�*�"0�]�����W+�Rz*�+����X��R�C��Vp�	���c.���*�5
%�Cp�cq�K+ճ(�<Ki���M��et:S��;�
q5��)g��y�)�����E}h:��*��=����	җ�BJܐ��Ba�nF-E�N���|��r�J7D�V����l��5�T�Q���a2j��4�cSi�4���%��P6�-�F�U��r���.c&�.���_|˲���w��M7��ٍ�/Z���.�����<tlѢ���*8r3>�e�g�i�2ԧ��+����7��6�<F~���V��.��{����ϟ?�?|�<�����#ڎ���D� V�>E�΀oISeۇ�]�@\ӛĕ^)�y�y��t���:#��� ���#2�q>A~����)P��8�8uG�g��{�y䁳8�,O]W� x�|�`���ҡG��"�2+G�k��t�t�� Od̯����������H/���G/8���A����ד ���
�;��ts�����T�
�/�Vf��z�;�0V%���4���Ŏܸ��;
���4���3"�_���926ifw��]���H���I�S�k�*��9?�t�l�㧫���3�z�폭�U^Ѣת����U�ɎN��h���s�cj|oo==VG_Q�lH��z?<�HPP� !=����%-�8F�G10E�6��'
,Բ� z& 1�"v*�2H}c�]\ �3�w�ؤaв�S�� �fq.���Ի��&������ �˩O��/O��jNW@���+��V��&>$�MO��`������z�_ g�ADVТ3��1���X뭭u�v �w�W���h~�ʬ��A�|��,] R�̢�'���g�*�L�*�?Yu�b[�h���%���q��{��юW�]�Ip��:�z�"�gm�}��e�tb���2z��$��6�O�aKK�I�8�j8���jQ;�+��@��z!�g䊉+�������ԃ��?�0Ӱ�M���	�����* �.6��u��~�_�/�LF�}=w�_�1t[=:�� ��`S!z,-{�Q�k28� ނ��>�)OB�P��Zm6����6o(�� )�O◧q���粫k@W�g/"��B�m��p~в���dM`e�%�s%k�hٺ2�^���-%O�{��Q�� 8\�a�n]\*��/ ���P�$U�/cX%m �cp.�bz��v_�a�Nv �ݶ��^q�Eo���#�c��� �	����ӔT�=rQ�@�J�&(�񟅜	}�vp��,�]� _�.� Q�6����*�u�ii�~��@����`WV�ce2����C�&͝�\2�o�nZ�<�t;h�Y�$�s�>�n�	r�#��[�E ���D�4kX򪋫�=]�8�	�e��X4(0����.�lto�x����c��� �ކ�8m1���j�i"�-B���W�Z%kݶ�����jBH��:3r
����23��z�:��:�k�'ش_@���1���^�U�͉�	�C��	�z?붉�ֆ�Ɖ�S�9�a1b%)��������_��$�-4egCi�@'(�w���w\qpl��b��Iߑ���j�����
$��܏:�����������������m�����+���b3�'�`��}$��!>!>A@j˶Jv�ܰe%�vr��h �oó�g���"?��g 2�3T1Z�����Q��+\����*vt��R��Y��\��ծu��'���ӱrEC�\�f�H!K�I5	Ij���HdH	�m�j�ZJ�#m\��f��?F��v���p8�H%��}[�����DX�ì�gN,�*�����l�Ƕx�O�'O�Pa̐k�bǂxf��W7��IM����&�bY�qB	�0)&IE�cJ�RQ%$5eBB
Y3�)ሂK��X|Ҵ�����c3�D���̲��o���7�;�$�亣q��	Ovfߓ�E�V�]����wd��cw���msE�+ZT��\�Μer�W�2�d�9�\��/�\�f�"W*=àu�]��[�K'�r�3x�E�����_pa�A��P���3���U�A���.��{��U@@�[;�3�Π���vF�\�'-���i���Z�3��b��-��o�A�6io��;]k�nxl熉Bw�!���V7g�j}��nz��0�b�ߊ�y!��sEy��&��W� t�>���l<Ǯr�<�rL9���"�qY6����P���(
�Y�3i�N�CǶz������Yy��?��m�&<Z�����ZES���e|�,ˉ�\�T�F��e�3����F�X�>���d=�k��bj�g@�=fY-�&��%�9�'K�4C��gq�e.�ϕ�)�q����N�1��E�/�A=�-�O�8��L>kK��\����"�xc0��EL���:Mݝﯡ���,���vs��:߲]��d�X��`��2V��~��0���{�F.u���N���ͮ��;V�ߊw�#�9+3V���@!t����3��m����zq`�&�f�_�$9��G���o��6n��!�|'뿏���KF�f�CD?��>�+���ķ�c���H/��MoI�	zH{H�X�[�*t��{I���'plS����A��#�K�ß��i�ʦ}��K������_ �����hhh^���f��W��#w��:�{I���9&Y����E�v$*����l�Ȗ"K�X$��*�EۡV�����pTib���	�u��,��j�Wa���m���k/�g�m�ɼq�O�}\S��:iet�:G�+b�M	�;�4��u%?��8ɍ��$P=��E��"m.U���rH!2��@��E��-�=�ޖ�����y�?����ޤS)N�Z*^	a1eV��a�;F5��؟?Y���WA����/�|�ocC�{���;�c�os��S���}�WA�؎���A��#�K�_������A��������?29��}�{�� �}�S�N����.���������Kz�?���@�S�����?��{��$�-�����Gz��?�#��%���/��3LP[����#BuBuBu�DC8����k�Nݶ�����-����pA�����xEE��G�X��N*U���S�J%��d��֚_-��`��?JA�_�A�_�������O�� ����?�V�:��v���C�o)x��7������)u�ޜe��~���!�-�\���,*��t!�����O�gv?��!z[����u����g�+�'�J�|����m�Y�8FO�].��Zh����v��f���.����$�4��sՑ�U�
�|��1G�vc�#��2��͏�2p��7Rs������'�#{���_m�L���^>���ۮ�C�󄤏�:N���f9��[�o�>��n�\9��0��H�#'�]QE#�:�����MiRh�C$��x8�G���ʆ叩O۽�~���4�eĜ��0����iP����P��� 
@5���k�Z�?��+C��R��F-���O8��]
 �	� �	򟪭��?�_����������_[�Ղ����
��Ԋ�����:��0�_ޜ��/������O�}�'{~F�f��>�$�o��oe����\׿���;�u���z��~��vR�!O|����p4�+=��{s;X��{T���.ѡU7��5�5r��
j�cb�I�f��3�7v~���І���SY����y�ϟ�z�y'@�y>מK�� ����i�#�>�{����Lu�kd�������Β�7�����|�O��`��TTTA->�{����Ùk��0d/WLt�aC͑u6U9��R\2ԇkcb���������?�_���[��l��B(�+ ��_[�Ձ��W�/����:��t�cL0��i��ؔb)�d)��8?DC�g}&�  h£� '� %:�����3~u��G��P���_���]W[�b!�7[M�F�$c���;�k�kǼ�h��m�+�K��ɲSks$�/�C��d�9��S�̻�n9>��c�I��!�َ��,�cIr�}����6#*R����z�6���u��C�gu����_A׷R����_u����Oe��?��?.e`�/�D����+뿃a��A���(b"9��ͧ�,�;9�,\wPV�%�[�'w	�'Ũߌ�8gt�K���Es��r+D���2BQF�Dr�V�ʅ��а��:��,�L�G5�i�.��{Q��?�oE���?��v��k�o@�`��:����������Z�4`���c�;�G����[��-.�/�����#r����c�{�09�O����颒�������[�A�\���g� @���3 �?�هg \�j�W���T��! o����YB�o6���Њd�/ѥ��!�F�)h�\��6˒�Xx#2�.��yy�`(����N<�{Qo�n���z�A�D��@ߍ���p��{z��� �i	�.\ꁝ�-�">~�z�Ƿ�Q��8$�Ŋ��
��T�5�=��e�h�.F��9ׅ���+w��/5."����Ox]6EUj��;��&;=t�@hL&Z[���LR�$�g��L�E����"䚡���H��j�N�69�o��G'�������h�_�E�:�?�|��H�e������E����z?�A1���:�?�>����)(��!ӯ�(��0��i������C�?��C���O��W�R��y>My��$�2So��!��yM�\Ƞ,͆��O��Ax�OY.$��h/���OC��G�(�J����u{�aY��CM�s��*���O���sc;$���Ĥ�_k ��4��g�*ȅ�lT�E�6{l�d�&�^��ݸ�����G�!���\yFm�qp�;ډ��]%�-��}/�p�������S
>���U?K�ߡ�����&0���@-�����a��$����tC�{��_5�_�:��U�����~���	����'h���������o ~��6���h��MA9'c&N��ʼ���J�%޻�˸1G~f����3���V6��y>2G��7��ǝj�Eޜ�V�vLLY�,[&�#c��6ZP{Z�#���ڛ�r4dVg6�4^kyS+�)�q7�%ְ5ӧ���Y�rma�BW�I��r����mG�;ƹ������
�t���ަk+T��ۡb��c�C�I�;�OeG�.;�j�d��4"��ַ'!�zG���|�6I�Bk3r�!w��H�,J����9O�V"����:�,d<��}��"�1ǩ��Z�e��:迋ڃ�+B9��w�+��������c�V�r���:���i��J���7���7��A�}��ۯ2� j	�������C��:���O_�PԢ���K�P������_�����j����Q�e�������C�~���(����'��/u�E�����������P5������8��*T��Q1����+������RP��p�
��_9�S����RP/��p��Q��h�	�� � ����#?�Z�?�������P��!�����j������I���ZH�C��(�����R ��� ��� ���?��P�m�W���e��C8D٨E�� �����R ��� ���Pm��@�A�c)����������_[�Ղ����8��Ԋ�a��tԡ����� ��0�������P��=��2P����>مP�W ���������p�Cy��c�E�h����@�˅���ـ#q"���N=4 H4�0��8c<��H�b��}�;��E���1��+���@^*��h��V�+�K���S*(h�]�ӌPTͻ]AK�&/}q{���qh(���jIaP4s���y~�;����Tw�E��F1$��*i�a��ås6ԙj�B��q%���h�$����!�|Sr�Զ�p
�<����ݓ����p�����P�����o������P�����P���\���_�/�:�?���W���ЩSc߳�Vc��Ⱦѝ�b{џ��/[X��?��^�?;\�2�&�k��n7W��� ���E�C�Qx�N-u�t&���b>IO
��ou��#��(��i�Y��2e@��^���w�;��%�����#������u������ �_���_����j�ЀU����a�����|���zO��7�'t�!!�����f�8�Bd���ke�Z�=k����Wp,���u �?"�:�ej͆t\r[��ړԏ�6F"S�ߎb��M���1��ht��#-Dڂ^�E��3"3�s܍�,�A���LW���v��啾f�=]:�:�o:-!ׅ�{a'DrK�����#o.�p�o7���q(H>��]'�u��,b�{����Ѳ�e���eST���w�����8��>�Su�5�Cd}�ܙu8p��t5>��xJ`��%*6���}c��x��1�[bٜmR�ٚ��}w~����4ܽ���?��E����3�������?��/u��0�A�'������?%���WmQ���q�'Q��/u�����$�(���s=!ӣ~(���1��y���(N��W���[���{��n�f���A�8�;�{�~ׁ�}�W��$޺����fi�+ώ�t�Q�^�
����?Y~�G���Y~�w�������_[��.D7�rp�.���5��sl���m!
^�VU��ꂐ_�Ά0�a��i#�WV_F����en'+�2�Ō��p�蚖�rѰS�[�51����b�r�d8W�U��1��]�����{�-Z���{r߼ɭ���\�\�&��k^��7�y�f���n���{b*Ef,��t'��h�vS�^��MnF�c�mR�E��i�,=Roۯ\��h� �ϻ��
XDv(�?0j:�͏�ܩ���©K�F�FB�4=!�N���\���,PWnJ��l�n0⬞��ɿ��wC-�u7��ߒP��c|
�i��|f�b$�q3"����$p3��Q����$��G0>P��h�Ma���P���~����`�������f|���~�|���n2��[oq;'��S�l��]!|����+V+�G��U����{�ٟ������������:�?�!�������?85F��M������A������nq�������g�=;���0:23��Yp��yv��_��^��z����1�o�m����j�!���ƺ�ܼ������~��|?���V�
��f�HwR�[��>9:jSn��5���v#^�}7��͋k?�T��'��3v6*��V'�մ3��~�G}���<��<_.ֱ�7��wfJC6f�)ɖW��Y���d>��ɲ�5����������z=�P;3�rܻ�(J�M3[/�<@��O���*E3S�a͹�	��*l��Mw�.:d3P���ܝUf���}����G�?��[
J��S�AH�,�3ǯ���|E1a8�}��<�c���]0e1
�p��<����'���������������_�M�S��O}9q�$\i�9�v����7O������e�U� �-��������~��c��2P�wQ{���W���{��_8᱖ �����!��:����1��������w�?�C�_
������������TUgm�nWf��,:����/�ptA��?t_���*����Gim�o!
ȷ�@�%[&tir6�ِ�gc�\S���=�r�ֹB>ں�u����+��忧�Nk������ض����N�[�n��S'�
Pl�oo��� ��S�_h��Nt&��4���S��� ��{���Z[�w]�u%���uNj�G�3�u����;z*��]k4�t]�o���j�t��9>�V{f4�{�Y�b9m�U:�[r�劘��?ݶZ�jx���)4����c�������q��Y�R7V<�oMֳ�F�k���^[�?^l��4���Vْ�6/Ju�����Bhj��1)uLy62��x5������*&-%�h�Y�Z?�z��ʀ)�u�ZIuG��e��8���j��I�.����\��O������7��dB�����W���m�/��?�#K��@�����2��/B�w&@�'�B�'���?�o��?��@.�����<�?���#c��Bp9#��E��D�a�?�����oP�꿃����y�/�W	�Y|����3$��ِ��/�C�ό�F�/���G�	�������J�/��f*�O�Q_; ���^�i�"�����u!����\��+�P��Y������J����CB��l��P��?�.����+㿐��	(�?H
A���m��B��� �##�����\������� ������0��_��ԅ@���m��B�a�9����\�������L��P��?@����W�?��O&���Bǆ�Ā���_.���R��2!����ȅ���Ȁ�������%����"P�+�F^`�����o��˃����Ȉ\���e�z����Qfh���V�6���V�Ě&_2)�����Z��eL�L�E��؏�[ݺ?=y��"w��C�6���;=e��Ex�:}���`W��ؔ��V�7�r�,IO��j]��XK��]��N�;u�dE?�)�Z�ƶ�͗�
�dG{�ݔ=!��4]�ݢ�:肸�Bbfk�6C�VXK2�*C�	���b���q�cתG��<s�����]����h�+���g��P7x��C��?с����0��������<�?������?�>qQ�����?��5�I˻Z�C���Hb1�(�e��q˶�Ӷ���rgO���_�:Z���`�э����fCM�"vX"�h�.�j��oՋ�mXù��5vy���|�TǮ6�Wr`R��
=	��ג���㿈@��ڽ����"�_�������/����/����؀Ʌ��r�_���f��G�����k��(����i=�0r�������M����+bM�ɔ��į�@q��`�r�M Alz�q�%I�ݟE�ݢ��ƚ>��uwR�K"}&V<.l����ة����$�M�Aj=z�\ks��u�]�6A��6�zE�6�l����ӯ��ya�h������d�]��]��OE�;���{Ex��$%N�� ;��YU+�c���{i�a/l>%��j�S(�tj9�����lԚ{�Lkl�,��fS�
��A����*aJ�t,�a�u�]��,�=btywุmȤ֮4����m������X��������v�`��������?�J�Y���,ȅ��W�x��,�L��^���}z@�A�Q�?M^��,ς�gR�O��P7�����\��+�?0��	����"�����G��̕���̈́<�?T�̞���{�?����=P��?B���%�ue��L@n��
�H�����\�?������?,���\���e�/������S���}��P�Ҿ=�#���*ߛps˸�����q�������ib��rW���a&�#M��^��;i������s��������nщ���x�ju~�I�Z�����be�Ì��yyC��Rѧ���!;3��08A���rf����i�������(M���h��s�/v%�Wӫ��#
��CK.H��G��m�>+�Z�[�e�:	�zޯ�L��3�uj�n6#���YMڒ��IV'��f5�������>v+E,D�\0k�0ۻce�2��4�}"8*�bu;���`�������n�[��۶�r��0���<���KȔ\��W�Q0��	P��A�/�����g`����ϋ��n����۶�r��,	������=` �Ʌ�������_����/�?�۱ר/"a�ri���As2����k����c�~�h�MomlF��4�����~��Pڇ�Zy�����E��T4��xOUg=��o*ڴEo�:_�!�)��+Q��>{�fq� h�v������Ʋ��#�s �4	��� `i��� �b!�	�=n��r���"�+�r�0e�U����taQ�{��'�zWRD6,oZr��#�rXa�)��A,�6u�+�ք�b}���n�&�ue����	���O���n����۶���E�J��"��G��2�Z��,N3�rI3�ER�-��9F�Xڢi�T6YʰH�'-�5L���r����1|���g&�m�O��φ��瀟�}�qK��t��'l$���Ҩ��'�^[�V5s���GoB��]0�@����OD��W�5&�X%^�vQ�Z��\�N%�.,OÎ9�z����,�T-+��>v�e7�����%�?��D��?]
u�8y����CG.����\��L�@�Mq��A���CǏ����n=^,kzGVEbNbb�h��r����֢�S�c'�n��?�/��p��}߯0���ˬ	)�c�c�:b'dq��uz@̏-��+>�jFmY7��zDg��q�Ckrp��ג���"������ y�oh� 0Br��_Ȁ�/����/������P�����<�,[�߲�Ʃ�gK������scw߱�@.��pK�!�y��)�G�, {^�e@ae�;m]墭�u���Պ�V���i��Z��Q�E%�S[Ec9+�ё���`���j�<�N���0�P��TiVhm��z)��ӗf��y�&��'>^�҈���օ8e�;��qS�:_ ��0`R��?a~�$��PWKUE҉ٶ�bN��w��1���(%g�)��Y�&��p�/�R��m��^ľ*(�T$�Օ��Ժ��eC�G��]�KN���qmώ-k`y�b��#��`��a�������Bo�gvw>�2=�8-�9����ő����>:�������Lb�}��4�������6]<�gZd�wO����/;����I��{A����H����#��w��_tHw���M\z�s�gSAN>&tB���E�.מ���?�_w�y���n��#J�u����LN�鏃�˃�?&w,��Z��ϛ�����y��>%Q�q�}��������q_��4����������q	]�7�zp"�sq�	�7�������F��^�O�Fs��=�~g��T��4���c䤯v��	=���?;W�$r��Ozd9�t<Z���39��	�����U�އw���s<��lx|����B������������;�����;����UrT��-�$��ݧ�;���|��H* �m��u�?��>���:y[�����|�n�^}�%�jy^?�f�6����	�<���Jvs\CK�Y��x�_�s]ǵ�u"o�������;�R���7�8P���p���k-H?��mt3��4���k����k��skrvg�=�O�y���L�M3 ���^:��~�7·���+���I�L�kaN��0#�X|n<�g�&��ɪ����)%-��"���Ɠڽ��N�����w�v��ȏ���I�	�0��څ_R�ûW5�2=�;��K����������>
                           �����E � 