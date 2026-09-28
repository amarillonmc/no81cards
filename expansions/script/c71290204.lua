--缇里西庇俄丝-命运的三子-
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290201)
	--①手卡特招手续：自己场上有5星以上的怪兽存在
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(cm.hspcon)
	c:RegisterEffect(e0)
	--②从场上离开：抽3张，之后可以从手卡特招同名卡；没有把怪兽特殊召唤的场合手卡全部送去墓地
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.tg2)
	e1:SetOperation(cm.op2)
	c:RegisterEffect(e1)
	--泰坦权能「雅努斯-万径之门-」：1回合1次，从手卡·墓地选1只有「翁法罗斯英雄纪」卡名记述的怪兽特殊召唤（需自身code flag）
	local t1=Effect.CreateEffect(c)
	t1:SetDescription(aux.Stringid(m,1))
	t1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	t1:SetType(EFFECT_TYPE_IGNITION)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(1)
	t1:SetCondition(cm.titancon)
	t1:SetTarget(cm.sptg)
	t1:SetOperation(cm.spop)
	c:RegisterEffect(t1)
	--献予「门径」之诗：升级版——自己·对方回合1次，从手卡·卡组·墓地选1只有「翁法罗斯英雄纪」卡名记述的怪兽特殊召唤
	local t2=t1:Clone()
	t2:SetDescription(aux.Stringid(m,2))
	t2:SetType(EFFECT_TYPE_QUICK_O)
	t2:SetCode(EVENT_FREE_CHAIN)
	t2:SetCondition(cm.upcon)
	t2:SetLabel(1)
	c:RegisterEffect(t2)
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.lv5filter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.lv5filter(c)
	return c:IsFaceup() and c:IsLevelAbove(5)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,3,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_HAND,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0
		and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)~=0 then return end
	else
		local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if hg:GetCount()>0 then
			Duel.SendtoGrave(hg,REASON_EFFECT)
		end
	end
end
function cm.spfilter2(c,e,tp)
	return c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--泰坦权能：基础=手卡·墓地，升级(label=1)=手卡·卡组·墓地
function cm.spfilter(c,e,tp)
	return aux.IsCodeListed(c,71290201) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local range=LOCATION_HAND
	if e:GetLabel()==1 then range=range+LOCATION_DECK end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter,e,tp),tp,range,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,range)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local range=LOCATION_HAND
	if e:GetLabel()==1 then range=range+LOCATION_DECK end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter,e,tp),tp,range,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
	end
end
function cm.titancon(e)
	return e:GetHandler():GetFlagEffect(m)~=0 and Duel.GetFlagEffect(e:GetHandlerPlayer(),71290201)==0
end
function cm.upcon(e)
	return e:GetHandler():GetFlagEffect(m)~=0 and Duel.GetFlagEffect(e:GetHandlerPlayer(),71290201)~=0
end
