--SCP-49 疫医
if not pcall(function() require("expansions/script/c16101100") end) then require("script/c16101100") end
local m,cm=rscf.DefineCard(16102000,"SCP")
local kh=c16102000
function c16102000.initial_effect(c)
	 c:EnableReviveLimit()
	--leave F 
	local e0=rsef.SV_REDIRECT(c,"leave",LOCATION_HAND,rscon.excard2(rscf.CheckSetCard,LOCATION_ONFIELD,0,1,nil,"SCP_J"))
	--SpecialSummonRule
	local e2=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,cm.sprcon,cm.sprop)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16102000,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,16102000)
	e3:SetCondition(kh.sprcon1)
	e3:SetTarget(kh.sptg)
	e3:SetOperation(kh.spop)
	c:RegisterEffect(e3)
	--disable and reduce ATK
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16102000,0))
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetCondition(kh.condition1)
	e4:SetTarget(kh.target)
	e4:SetOperation(kh.operation)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetHintTiming(TIMING_DAMAGE_STEP,0x21e0)
	e5:SetCondition(kh.condition2)
	c:RegisterEffect(e5)
	
end
function cm.spcfilter(c,tp)
	return c:IsReleasable() and c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function cm.spzfilter(c,tp)
	return Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.sprcon(e,c,tp)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(Card.IsCode,nil,16102002)
	local g2=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_MZONE,0,nil,tp)
	return (g1+g2):IsExists(cm.spzfilter,1,nil,tp)
end
function cm.sprop(e,tp)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(Card.IsCode,nil,16102002)
	local g2=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_MZONE,0,nil,tp)
	local sg=(g1+g2):SelectSubGroup(tp,cm.spzfilter,false,1,1,tp)
	Duel.Release(sg,REASON_COST)
end
function kh.tgrfilter(c)
	return  c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLocation(LOCATION_GRAVE)
end
function kh.sprcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(kh.tgrfilter,1,nil)
end
function kh.spfilter(c,e,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) 
		and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP) and c:IsType(TYPE_MONSTER)
end
function kh.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and eg:IsExists(kh.spfilter,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,eg,1,0,0)
end
function kh.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local sg=nil
	local g=eg:Filter(kh.spfilter,nil,e,tp)
	if g:GetCount()==0 then return end
	if g:GetCount()==1 then
		sg=g
	else
		sg=g:Select(tp,1,1,nil)
	end
	if Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)~=0 then
	sg=sg:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e1:SetValue(LOCATION_REMOVED)
	sg:RegisterEffect(e1,true)
	end
end
function kh.descfilter(c)
	return c:IsFaceup() and c:CheckSetCard("SCP") and not c:CheckSetCard("SCP_J") and not c:IsCode(16102000)
end
function kh.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(kh.descfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function kh.filter1(c)
	return c:IsFaceup()
end
function kh.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and kh.filter1(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(kh.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,kh.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function kh.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local op=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))
		if op==0 then
			Duel.Recover(tc:GetControler(),tc:GetTextAttack(),REASON_EFFECT)
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_ATTACK)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CANNOT_TRIGGER)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e4:SetRange(LOCATION_MZONE)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
		end
		if op==1 then 
			local L1=Duel.GetLP(tc:GetControler())
			if L1<tc:GetTextAttack() then Duel.SetLP(tc:GetControler(),0) end
			if L1>=tc:GetTextAttack() then Duel.SetLP(tc:GetControler(),L1-tc:GetTextAttack()) end
			local e1=Effect.CreateEffect(c)
			e1:SetCategory(CATEGORY_ATKCHANGE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(tc:GetAttack()*2)   
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		 end 
	end
end
function kh.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(kh.descfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end