--雷高龙-雷龙 萝玛洛尼亚
local cm,m,o=GetID()
cm.name = "雷高龙-雷龙 萝玛洛尼亚"
function cm.initial_effect(c)
	--spsummon1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,m)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.sgcost)
	e2:SetTarget(cm.sgtg)
	e2:SetOperation(cm.sgop)
	c:RegisterEffect(e2)
	--spsummon2
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(m,1))
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_ATTACK_ANNOUNCE)
	e11:SetCountLimit(1,m+10000000)
	e11:SetTarget(cm.sptg1)
	e11:SetOperation(cm.spop1)
	c:RegisterEffect(e11)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29491334,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1,m+20000000)
	e1:SetTarget(cm.sptg2)
	e1:SetOperation(cm.spop2)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetLabel(m)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(cm.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_REMOVE)
		ge2:SetLabel(m)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.costfilter(c)
	return c:IsRace(RACE_THUNDER) and c:IsDiscardable()
end
function cm.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,cm.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function cm.sgfil(c,e,tp)
	return c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.sgfil,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function cm.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sgfil,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function cm.spfil1(c,e,tp)
	return c:IsSetCard(0x11c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfil1,tp,LOCATION_HAND,0,1,nil,e,tp)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfil1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(2000)
		tc:RegisterEffect(e1)
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e9:SetCode(EVENT_BATTLED)
		e9:SetOperation(cm.batop)
		e9:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e9)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(m,3))
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_DAMAGE_STEP_END)
		e3:SetCondition(aux.dsercon)
		e3:SetTarget(cm.rcttg)
		e3:SetOperation(cm.rctop)
		e3:SetLabelObject(e9)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.batop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc and c:IsAttackPos() then
		e:SetLabel(bc:GetAttack())
		e:SetLabelObject(bc)
	else
		e:SetLabelObject(nil)
	end
end
function cm.rcttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetLabelObject():GetLabelObject()
	if chk==0 then return bc end
	if bc:IsRelateToBattle() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
	end
end
function cm.rctop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject():GetLabelObject()
	--local KOI=false
	--if Duel.Exile then KOI=true end
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
		if e:GetHandler():IsCode(60002325) then --and KOI==true and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			Duel.Hint(HINT_CARD,1-tp,60002326)
			Duel.Hint(HINT_CARD,1-tp,60002327)
			Duel.Hint(HINT_CARD,1-tp,60002328)
			Duel.Hint(HINT_CARD,1-tp,60002329)
			Duel.Hint(HINT_CARD,1-tp,60002330)
			Duel.Hint(HINT_CARD,1-tp,60002331)
			--e:GetHandler():SetCardData(CARDDATA_CODE,60002326)
			--e:GetHandler():SetCardData(CARDDATA_CODE,60002327)
			--e:GetHandler():SetCardData(CARDDATA_CODE,60002328)
			--e:GetHandler():SetCardData(CARDDATA_CODE,60002329)
			--e:GetHandler():SetCardData(CARDDATA_CODE,60002330)
			--e:GetHandler():SetCardData(CARDDATA_CODE,60002331)
			--e:GetHandler():SetCardData(CARDDATA_CODE,60002325)
		end
	end
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_THUNDER)
end
function cm.sumreg(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local code=e:GetLabel()
	while tc do
		if tc:GetOriginalCode()==code then
			tc:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,3)
		end
		tc=eg:GetNext()
	end
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():GetFlagEffect(m)~=0
		and Duel.IsExistingMatchingCard(cm.spfil1,tp,LOCATION_HAND,0,1,nil,e,tp)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfil1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(2000)
		tc:RegisterEffect(e1)
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e9:SetCode(EVENT_BATTLED)
		e9:SetOperation(cm.batop)
		e9:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e9)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(m,3))
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_DAMAGE_STEP_END)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCondition(aux.dsercon)
		e3:SetTarget(cm.rcttg)
		e3:SetOperation(cm.rctop)
		e3:SetLabelObject(e9)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
end