--星-记忆-
--卡名规则上当作「开拓者」使用（alias=60010045）
--这张卡与衍生物的泰坦权能不受昔涟①升级影响（权能条件只查自身flag，不写升级分支/玩家flag互斥）
--字符串：0=①、1=泰坦权能「? ? ?」、2=●宣言等级、3=②、4=②检索询问、5=权能翻卡询问
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290201)
	--①自己场上有等级为13的怪兽存在的场合才能发动：这张卡从手卡特殊召唤，得到●效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	--②1回合1次，丢弃1张手卡：选自己场上1只记述怪兽得到对应的泰坦权能，那之后可检索同等级记述怪+特招对应衍生物并得到泰坦权能
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	--泰坦权能「? ? ?」：1回合1次，选自己场上1张卡回到手卡，那之后可翻卡组顶3张选1张记述卡送去墓地
	--开拓者同名卡权能：检测自身code或60010045的flag均可（真开拓者无脚本时由授予方手动注册）
	local t1=Effect.CreateEffect(c)
	t1:SetDescription(aux.Stringid(m,1))
	t1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	t1:SetType(EFFECT_TYPE_IGNITION)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(1)
	t1:SetCondition(cm.titancon)
	t1:SetTarget(cm.t1tg)
	t1:SetOperation(cm.t1op)
	c:RegisterEffect(t1)
end
--①
function cm.lv13filter(c)
	return c:IsFaceup() and c:IsLevel(13)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(cm.lv13filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)~=0 then
		cm.reglevel(c)
	end
end
--●宣言等级：常驻CHANGE_LEVEL效果的label存宣言数字，●只改label（避免重复注册叠加）
function cm.reglevel(sc)
	local elv=Effect.CreateEffect(sc)
	elv:SetType(EFFECT_TYPE_SINGLE)
	elv:SetCode(EFFECT_CHANGE_LEVEL)
	elv:SetCondition(cm.lvsetcon)
	elv:SetValue(cm.lvsetval)
	elv:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(elv)
	local ed=Effect.CreateEffect(sc)
	ed:SetDescription(aux.Stringid(m,2))
	ed:SetType(EFFECT_TYPE_IGNITION)
	ed:SetRange(LOCATION_MZONE)
	ed:SetCountLimit(1)
	ed:SetLabelObject(elv)
	ed:SetTarget(cm.lvtg)
	ed:SetOperation(cm.lvop)
	sc:RegisterEffect(ed)
end
function cm.lvsetcon(e)
	return e:GetLabel()~=0
end
function cm.lvsetval(e)
	return e:GetLabel()
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local num=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,10,11,12,13)
	local elv=e:GetLabelObject()
	if elv then
		elv:SetLabel(num)
	end
end
--②
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function cm.gtfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,71290201)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.gtfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.gtfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.gtfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		cm.grant(tc)
	end
	--那之后，可以从卡组把1只和这张卡相同等级的记述怪兽加入手卡，特招对应衍生物
	local lv=c:GetLevel()
	if Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil,lv)
		and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil,lv)
		local sc=g:GetFirst()
		if sc then
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				local token=Duel.CreateToken(tp,cm.tkcode(sc))
				cm.tokeninit(token,sc)
				if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)~=0 then
					cm.regititan(token,sc)
				end
			end
		end
	end
end
function cm.thfilter2(c,lv)
	return aux.IsCodeListed(c,71290201) and c:IsLevel(lv) and c:IsAbleToHand()
end
--授予泰坦权能（场上怪兽用）
function cm.grant(tc)
	if tc:IsCode(60010045) then
		--开拓者同名卡（含星-记忆-）：权能检测始终使用真实卡名60010045
		local first=tc:GetFlagEffect(60010045)==0
		tc:RegisterFlagEffect(60010045,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
		--真开拓者(60010045)无脚本：手动注册「? ? ?」效果（仅首次授予时）
		if first and not tc:IsCode(71290242) then
			cm.rtblazer(tc)
		end
	else
		local code=tc:GetOriginalCode()
		tc:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,cm.hintid[code] or 1))
	end
end
--衍生物code映射：星-记忆-→71290241，昔涟→71290240，开拓者→71290241，其余=code+2
--注意：星-记忆-的alias是60010045，IsCode(60010045)对其也为真，必须先判71290242
function cm.tkcode(sc)
	if sc:IsCode(71290202) then return 71290240 end
	if sc:IsCode(60010045) then return 71290241 end
	return sc:GetOriginalCode()+2
end
--衍生物属性·种族·等级·攻守复制（与加入手卡的怪兽相同）
function cm.tokeninit(token,sc)
	local e1=Effect.CreateEffect(token)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(sc:GetAttribute())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(sc:GetRace())
	token:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(sc:GetLevel())
	token:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetValue(sc:GetAttack())
	token:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e5:SetValue(sc:GetDefense())
	token:RegisterEffect(e5)
end
--为衍生物手动注册源卡对应的基础泰坦权能并放置flag激活（均不受昔涟①升级影响，条件只查自身flag）
function cm.regititan(token,sc)
	if sc:IsCode(60010045) then
		--开拓者同名卡（含星-记忆-）：flag固定60010045
		cm.rtblazer(token)
		token:RegisterFlagEffect(60010045,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	elseif sc:IsCode(71290202) then
		cm.rt71290202(token)
		token:RegisterFlagEffect(71290202,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71290202,3))
	elseif sc:IsCode(71290204) then
		cm.rt71290204(token)
		token:RegisterFlagEffect(71290204,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71290204,1))
	elseif sc:IsCode(71290207) then
		cm.rt71290207(token)
		token:RegisterFlagEffect(71290207,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71290207,2))
	elseif sc:IsCode(71290210) then
		cm.rt71290210(token)
		token:RegisterFlagEffect(71290210,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71290210,1))
	elseif sc:IsCode(71290213) then
		cm.rt71290213(token)
		token:RegisterFlagEffect(71290213,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71290213,2))
	elseif sc:IsCode(71290216) then
		cm.rt71290216(token)
		token:RegisterFlagEffect(71290216,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71290216,1))
	elseif sc:IsCode(71290219) then
		cm.rt71290219(token)
		token:RegisterFlagEffect(71290219,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71290219,1))
	elseif sc:IsCode(71290222) then
		cm.rt71290222(token)
		token:RegisterFlagEffect(71290222,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71290222,1))
	elseif sc:IsCode(71290225) then
		cm.rt71290225(token)
		token:RegisterFlagEffect(71290225,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71290225,3))
	elseif sc:IsCode(71290228) then
		cm.rt71290228(token)
		token:RegisterFlagEffect(71290228,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71290228,1))
	elseif sc:IsCode(71290231) then
		cm.rt71290231(token)
		token:RegisterFlagEffect(71290231,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71290231,2))
	elseif sc:IsCode(71290234) then
		cm.rt71290234(token)
		token:RegisterFlagEffect(71290234,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71290234,1))
	elseif sc:IsCode(71290237) then
		cm.rt71290237(token)
		token:RegisterFlagEffect(71290237,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71290237,1))
	end
	
end
--授予提示字符串映射（默认stringid 1；特殊：德缪歌/塔兰顿用新增串，吉奥里亚/尼卡多利权能描述为stringid 2）
cm.hintid={[71290202]=3,[71290207]=2,[71290213]=2,[71290225]=3,[71290231]=2}
--泰坦权能「? ? ?」共用目标/操作（自己场上1张卡回手，那之后可翻卡组顶3张选1张记述卡送墓）
function cm.titancon(e)
	return e:GetHandler():GetFlagEffect(m)~=0 or e:GetHandler():GetFlagEffect(60010045)~=0
end
function cm.gravefilter(c,tp)
	return aux.IsCodeListed(c,71290201) and c:IsAbleToGrave()
end
function cm.t1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function cm.t1op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	--那之后，可以翻开自己卡组最上面3张卡，从那之中选1张记述卡送去墓地
	local ct=3
	if ct>0 and Duel.GetDecktopGroup(tp,ct):FilterCount(cm.gravefilter,nil,tp)>0
		and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
		Duel.ConfirmDecktop(tp,ct)
		local dg=Duel.GetDecktopGroup(tp,ct):Filter(cm.gravefilter,nil,tp)
		if dg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=dg:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
--「? ? ?」衍生物/真开拓者版（flag只查60010045，与本体共用计数=同名卡共用1回合1次）
function cm.rtblazer(tc)
	local t1=Effect.CreateEffect(tc)
	t1:SetDescription(aux.Stringid(m,1))
	t1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	t1:SetType(EFFECT_TYPE_IGNITION)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(1,m+100)
	t1:SetCondition(cm.blazercon)
	t1:SetTarget(cm.t1tg)
	t1:SetOperation(cm.t1op)
	tc:RegisterEffect(t1)
end
function cm.blazercon(e)
	return e:GetHandler():GetFlagEffect(60010045)~=0
end
--=昔涟(71290202)「德缪歌」：攻守=场上记述怪兽数×4000（基础版，无升级抗性）
function cm.rt71290202(token)
	local t1=Effect.CreateEffect(token)
	t1:SetType(EFFECT_TYPE_SINGLE)
	t1:SetCode(EFFECT_SET_ATTACK_FINAL)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCondition(cm.titancon202)
	t1:SetValue(cm.atkval202)
	token:RegisterEffect(t1)
	local t2=t1:Clone()
	t2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	token:RegisterEffect(t2)
end
function cm.titancon202(e)
	return e:GetHandler():GetFlagEffect(71290202)~=0
end
function cm.omfilter202(c)
	return aux.IsCodeListed(c,71290201) and c:IsFaceup()
end
function cm.atkval202(e,c)
	return Duel.GetMatchingGroupCount(cm.omfilter202,c:GetControler(),LOCATION_MZONE,0,nil)*4000
end
--=缇里西庇俄丝(71290204)「雅努斯-万径之门-」：1回合1次从手卡·墓地特招记述怪兽
function cm.rt71290204(token)
	local t1=Effect.CreateEffect(token)
	t1:SetDescription(aux.Stringid(71290204,1))
	t1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	t1:SetType(EFFECT_TYPE_IGNITION)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(1)
	t1:SetCondition(cm.titancon204)
	t1:SetTarget(cm.rt204tg)
	t1:SetOperation(cm.rt204op)
	token:RegisterEffect(t1)
end
function cm.titancon204(e)
	return e:GetHandler():GetFlagEffect(71290204)~=0
end
function cm.rt204filter(c,e,tp)
	return aux.IsCodeListed(c,71290201) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rt204tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.rt204filter,e,tp),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.rt204op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.rt204filter,e,tp),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
	end
end
--=刻律德菈(71290207)「塔兰顿-公正之秤-」：自己场上其他怪兽不会被战斗破坏
function cm.rt71290207(token)
	local t1=Effect.CreateEffect(token)
	t1:SetType(EFFECT_TYPE_FIELD)
	t1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	t1:SetRange(LOCATION_MZONE)
	t1:SetTargetRange(LOCATION_MZONE,0)
	t1:SetCondition(cm.titancon207)
	t1:SetTarget(cm.rt207othertg)
	t1:SetValue(1)
	token:RegisterEffect(t1)
end
function cm.titancon207(e)
	return e:GetHandler():GetFlagEffect(71290207)~=0
end
function cm.rt207othertg(e,c)
	return c~=e:GetHandler()
end
--=长夜月(71290210)「欧洛尼斯-永夜之帷-」：1回合1次翻卡组顶3张选1张记述卡入手
function cm.rt71290210(token)
	local t1=Effect.CreateEffect(token)
	t1:SetDescription(aux.Stringid(71290210,1))
	t1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	t1:SetType(EFFECT_TYPE_IGNITION)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(1)
	t1:SetCondition(cm.titancon210)
	t1:SetTarget(cm.rt210tg)
	t1:SetOperation(cm.rt210op)
	token:RegisterEffect(t1)
end
function cm.titancon210(e)
	return e:GetHandler():GetFlagEffect(71290210)~=0
end
function cm.rt210filter(c)
	return aux.IsCodeListed(c,71290201) and c:IsAbleToHand()
end
function cm.rt210tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetDecktopGroup(tp,3):FilterCount(cm.rt210filter,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.rt210op(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3):Filter(cm.rt210filter,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
--=丹恒(71290213)「吉奥里亚-磐岩之脊-」：1回合1次，对方把效果发动时无效
function cm.rt71290213(token)
	local t1=Effect.CreateEffect(token)
	t1:SetDescription(aux.Stringid(71290213,2))
	t1:SetCategory(CATEGORY_DISABLE)
	t1:SetType(EFFECT_TYPE_QUICK_O)
	t1:SetCode(EVENT_CHAINING)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(1)
	t1:SetCondition(cm.rt213con)
	t1:SetTarget(cm.rt213tg)
	t1:SetOperation(cm.rt213op)
	token:RegisterEffect(t1)
end
function cm.rt213con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetFlagEffect(71290213)~=0
		and Duel.IsChainNegatable(ev)
end
function cm.rt213tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.rt213op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
--=海列屈拉(71290216)「法吉娜-满溢之杯-」：自己把4星以下记述怪特招成功时翻卡组顶3张选1张入手洗切（无次数限制）
function cm.rt71290216(token)
	local t1=Effect.CreateEffect(token)
	t1:SetDescription(aux.Stringid(71290216,1))
	t1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	t1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	t1:SetCode(EVENT_SPSUMMON_SUCCESS)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCondition(cm.rt216con)
	t1:SetTarget(cm.rt216tg)
	t1:SetOperation(cm.rt216op)
	token:RegisterEffect(t1)
end
function cm.rt216chk(c,tp)
	return aux.IsCodeListed(c,71290201) and c:IsLevelBelow(4) and c:GetSummonPlayer()==tp
end
function cm.rt216con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(71290216)~=0
		and eg:IsExists(cm.rt216chk,1,nil,tp)
end
function cm.rt216tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.rt216op(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleDeck(tp)
end
--=雅辛忒丝(71290219)「艾格勒-晨昏之眼-」：自己把记述怪特招成功时1回合1次回复1000，那之后可墓地记述怪入手
function cm.rt71290219(token)
	local t1=Effect.CreateEffect(token)
	t1:SetDescription(aux.Stringid(71290219,1))
	t1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH)
	t1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	t1:SetCode(EVENT_SPSUMMON_SUCCESS)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(1)
	t1:SetCondition(cm.rt219con)
	t1:SetTarget(cm.rt219tg)
	t1:SetOperation(cm.rt219op)
	token:RegisterEffect(t1)
end
function cm.rt219chk(c,tp)
	return aux.IsCodeListed(c,71290201) and c:GetSummonPlayer()==tp
end
function cm.rt219con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(71290219)~=0
		and eg:IsExists(cm.rt219chk,1,nil,tp)
end
function cm.rt219filter(c)
	return aux.IsCodeListed(c,71290201) and c:IsAbleToHand()
end
function cm.rt219tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rt219filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.rt219op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1000,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.rt219filter),tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(71290219,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.rt219filter),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
--=卡尼斯兰那(71290222)「刻法勒-全世之座-」：选其他怪兽任意破坏，从墓地选相同数量记述怪装备（每回合最多33550336次）
function cm.rt71290222(token)
	local t1=Effect.CreateEffect(token)
	t1:SetDescription(aux.Stringid(71290222,1))
	t1:SetCategory(CATEGORY_DESTROY+CATEGORY_EQUIP)
	t1:SetType(EFFECT_TYPE_IGNITION)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(33550336)
	t1:SetCondition(cm.titancon222)
	t1:SetTarget(cm.rt222tg)
	t1:SetOperation(cm.rt222op)
	token:RegisterEffect(t1)
end
function cm.titancon222(e)
	return e:GetHandler():GetFlagEffect(71290222)~=0
end
function cm.rt222eqfilter(c)
	return c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,71290201)
end
function cm.rt222tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,e:GetHandler()):GetCount()>0
			and Duel.IsExistingMatchingCard(cm.rt222eqfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function cm.rt222op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,c)
	local g2=Duel.GetMatchingGroup(cm.rt222eqfilter,tp,LOCATION_GRAVE,0,nil)
	local maxn=math.min(g1:GetCount(),g2:GetCount())
	if maxn<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g1:Select(tp,1,maxn,nil)
	local n=sg:GetCount()
	if n>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
	--破坏处理后再从墓地选（含刚被破坏送墓的记述怪兽）
	local g3=Duel.GetMatchingGroup(cm.rt222eqfilter,tp,LOCATION_GRAVE,0,nil)
	if n>0 and g3:GetCount()>=n and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local eq=g3:Select(tp,n,n,nil)
		local tcc=eq:GetFirst()
		while tcc do
			Duel.Equip(tp,tcc,c,false,true)
			tcc=eq:GetNext()
		end
		Duel.EquipComplete()
	end
end
--=阿那克萨戈拉斯(71290225)「瑟希斯-裂分之枝-」：1回合1次至多2只怪兽送墓，从手卡·墓地特招相同数量记述怪（基础版）
function cm.rt71290225(token)
	local t1=Effect.CreateEffect(token)
	t1:SetDescription(aux.Stringid(71290225,3))
	t1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	t1:SetType(EFFECT_TYPE_IGNITION)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(1,71290225+100)
	t1:SetCondition(cm.titancon225)
	t1:SetCost(cm.rt225cost)
	t1:SetTarget(cm.rt225tg)
	t1:SetOperation(cm.rt225op)
	token:RegisterEffect(t1)
end
function cm.titancon225(e)
	return e:GetHandler():GetFlagEffect(71290225)~=0
end
function cm.rt225filter(c,e,tp)
	return aux.IsCodeListed(c,71290201) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rt225cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil)>0
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.rt225filter,e,tp),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	if chk==1 then
		local maxn=math.min(2,
			Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil),
			Duel.GetMatchingGroupCount(aux.NecroValleyFilter(cm.rt225filter,e,tp),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,maxn,nil)
		Duel.SendtoGrave(g,REASON_COST)
		e:SetLabel(g:GetCount())
	end
end
function cm.rt225tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetLabel(),tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.rt225op(e,tp,eg,ep,ev,re,r,rp)
	local n=e:GetLabel()
	if n<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.rt225filter,e,tp),tp,LOCATION_HAND+LOCATION_GRAVE,0,n,n,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
	end
end
--=阿格莱雅(71290228)「墨涅塔-黄金之茧-」：1回合1次墓地2星以下记述怪入手
function cm.rt71290228(token)
	local t1=Effect.CreateEffect(token)
	t1:SetDescription(aux.Stringid(71290228,1))
	t1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	t1:SetType(EFFECT_TYPE_IGNITION)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(1)
	t1:SetCondition(cm.titancon228)
	t1:SetTarget(cm.rt228tg)
	t1:SetOperation(cm.rt228op)
	token:RegisterEffect(t1)
end
function cm.titancon228(e)
	return e:GetHandler():GetFlagEffect(71290228)~=0
end
function cm.rt228filter(c)
	return c:IsLevelBelow(2) and not c:IsType(TYPE_XYZ+TYPE_LINK)
		and aux.IsCodeListed(c,71290201) and c:IsAbleToHand()
end
function cm.rt228tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.rt228filter),tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.rt228op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.rt228filter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--=迈德谟斯(71290231)「尼卡多利-天谴之矛-」：自己·对方的战斗阶段对方不能把效果发动
function cm.rt71290231(token)
	local t1=Effect.CreateEffect(token)
	t1:SetDescription(aux.Stringid(71290231,2))
	t1:SetType(EFFECT_TYPE_FIELD)
	t1:SetCode(EFFECT_CANNOT_ACTIVATE)
	t1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	t1:SetRange(LOCATION_MZONE)
	t1:SetTargetRange(0,1)
	t1:SetValue(1)
	t1:SetCondition(cm.rt231con)
	token:RegisterEffect(t1)
end
function cm.rt231con(e)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():GetFlagEffect(71290231)~=0
		and ph>=PHASE_BATTLE_START and ph<=PHASE_DAMAGE_CAL
end
--=遐蝶(71290234)「塞纳托斯-灰黯之手-」：1回合1次墓地记述怪特招
function cm.rt71290234(token)
	local t1=Effect.CreateEffect(token)
	t1:SetDescription(aux.Stringid(71290234,1))
	t1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	t1:SetType(EFFECT_TYPE_IGNITION)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(1)
	t1:SetCondition(cm.titancon234)
	t1:SetTarget(cm.rt234tg)
	t1:SetOperation(cm.rt234op)
	token:RegisterEffect(t1)
end
function cm.titancon234(e)
	return e:GetHandler():GetFlagEffect(71290234)~=0
end
function cm.rt234filter(c,e,tp)
	return aux.IsCodeListed(c,71290201) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rt234tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.rt234filter),tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.rt234op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.rt234filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
	end
end
--=赛法利娅(71290237)「扎格列斯-翻飞之币-」：1回合1次猜拳（平局重猜），赢的玩家抽2张
function cm.rt71290237(token)
	local t1=Effect.CreateEffect(token)
	t1:SetDescription(aux.Stringid(71290237,1))
	t1:SetCategory(CATEGORY_DRAW)
	t1:SetType(EFFECT_TYPE_IGNITION)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(1)
	t1:SetCondition(cm.titancon237)
	t1:SetTarget(cm.rt237tg)
	t1:SetOperation(cm.rt237op)
	token:RegisterEffect(t1)
end
function cm.titancon237(e)
	return e:GetHandler():GetFlagEffect(71290237)~=0
end
function cm.rt237tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.rt237op(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.RockPaperScissors()
	while res~=0 and res~=1 do
		res=Duel.RockPaperScissors()
	end
	Duel.Draw(res,2,REASON_EFFECT)
end
