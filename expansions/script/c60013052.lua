-- 灵光一闪衍生物（「凶兆的使徒 罗丝薇瑟」专用）
-- 本文件同时是 60013050~60013062 这一批「灵光一闪」卡共用的工具库。
-- 只放不依赖具体卡 handler / effect 对象的纯函数，避免跨卡调用 operation 造成的 bug。
local cm,m,o=GetID()

Lingguang=Lingguang or {}
Lingguang.token=60013052		-- 灵光一闪衍生物
Lingguang.rose=60013050			-- 「凶兆的使徒 罗丝薇瑟」
Lingguang.kelken=60012777		-- 「神之灵光一闪 凯尔肯」（规则上卡名当作灵光一闪衍生物）
Lingguang.sui=60013053			-- 「剑穗」
Lingguang.field=60013062		-- 「凯尔肯的使徒」
-- 自定义时点：有「罗丝薇瑟」卡名记述的魔陷适用了【灵光一闪】，供「凯尔肯的使徒」②诱发
Lingguang.EV=EVENT_CUSTOM+60013062

function cm.initial_effect(c)
end

-- 「灵光一闪衍生物」的判定：直接用最初的灵光 token 的卡号 60013002
-- cdb 里 60013052（衍生物）与 60012777（凯尔肯）的 alias 都是 60013002，规则上同名
function Lingguang.tokfilter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_SZONE) and c:IsCode(60013002)
end

-- 卡组·墓地里当作「灵光一闪衍生物」的卡（「凶兆的使徒 罗丝薇瑟」②、 「凯尔肯的使徒」① 用）
-- 光有衍生物卡号还不够：本家其他卡也可能同名，必须再加凯尔肯自己的标记
function Lingguang.kelkenfilter(c)
	return c:IsCode(60013002) and c.isKelken==true
end

-- 这张卡是否记述「凶兆的使徒 罗丝薇瑟」（决定能否用「剑穗」代替破坏）
function Lingguang.isrose(c)
	return c~=nil and aux.IsCodeListed(c,60013050)
end

-- 「剑穗」
function Lingguang.suifilter(c)
	return c:IsCode(60013053) and c:IsAbleToGrave()
end

-- 「凶兆的使徒 罗丝薇瑟」（含同名异画 60013051）
function Lingguang.rosefilter(c)
	return c:IsCode(60013050,60013051)
end

-- 自己场上是否有可以破坏的「灵光一闪衍生物」
function Lingguang.canlf(tp)
	return Duel.IsExistingMatchingCard(Lingguang.tokfilter,tp,LOCATION_SZONE,0,1,nil)
end

-- 这张卡能否用「剑穗」代替破坏（必须记述「罗丝薇瑟」+ 手卡有剑穗）
function Lingguang.cansui(c,tp)
	return Lingguang.isrose(c)
		and Duel.IsExistingMatchingCard(Lingguang.suifilter,tp,LOCATION_HAND,0,1,nil)
end

-- 能否支付【灵光一闪】的代价：场上有衍生物，或者有「剑穗」代替
-- 注意：场上没有衍生物、只有「剑穗」时也可以适用灵光一闪（用户裁定）
function Lingguang.canpay(c,tp)
	return Lingguang.canlf(tp) or Lingguang.cansui(c,tp)
end

-- 支付【灵光一闪】的代价：破坏1只灵光一闪衍生物；
-- 若这张卡记述「罗丝薇瑟」，也可以从手卡把1张「剑穗」送去墓地代替（「剑穗」的替代效果内置在这里）
-- 没有衍生物但有剑穗时，直接送剑穗
-- 返回 true = 代价支付成功
function Lingguang.pay(c,tp)
	local can_tok=Lingguang.canlf(tp)
	local can_sui=Lingguang.cansui(c,tp)
	if not can_tok and not can_sui then return false end
	local use_sui=false
	if can_sui then
		if can_tok then
			-- 0=破坏衍生物 1=把剑穗送去墓地代替
			use_sui=Duel.SelectOption(tp,aux.Stringid(60013053,2),aux.Stringid(60013053,3))==1
		else
			use_sui=true
		end
	end
	if use_sui then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,Lingguang.suifilter,tp,LOCATION_HAND,0,1,1,nil)
		if #sg==0 then return false end
		return Duel.SendtoGrave(sg,REASON_EFFECT)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.GetMatchingGroup(Lingguang.tokfilter,tp,LOCATION_SZONE,0,nil):Select(tp,1,1,nil)
	if #dg==0 then return false end
	return Duel.Destroy(dg,REASON_EFFECT)>0
end

-- 适用完【灵光一闪】后调用：支付代价；若这张卡记述「罗丝薇瑟」，再发出自定义时点
-- e 传当前效果对象（Duel.RaiseEvent 的第3个参数不能为 nil）
function Lingguang.lf(c,tp,e)
	if not Lingguang.pay(c,tp) then return false end
	if Lingguang.isrose(c) then
		Duel.RaiseEvent(c,Lingguang.EV,e,REASON_EFFECT,tp,tp,1)
	end
	return true
end

-- 把加入手卡的卡持续公开（照「蜃气楼」的写法），desc 传 aux.Stringid(m, index)
function Lingguang.pub(c,e,desc)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,desc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

-- 选择选项：只显示可用的项，返回 opts 里第三个数（原始选项编号）
-- 不直接用 aux.SelectFromOptions，是因为它在过滤掉不可用项后返回的是「可用列表里的序号」，会和原本的 op 编号错位
function Lingguang.select(tp,opts)
	local hints={}
	local keys={}
	for i,o in ipairs(opts) do
		if o[1] then
			hints[#hints+1]=o[2]
			keys[#keys+1]=o[3] or i
		end
	end
	if #hints==0 then return 0 end
	local sel=Duel.SelectOption(tp,table.unpack(hints))+1
	return keys[sel] or 0
end
