local m=82204235
local cm=_G["c"..m]
cm.name="虚妄灵质 凝光原核"
function cm.initial_effect(c)
	--flip check
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e1:SetCode(EVENT_FLIP)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e1:SetOperation(cm.chkop)  
	c:RegisterEffect(e1) 
	--flip  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_CHAINING)  
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.flipcon)  
	e2:SetCost(cm.flipcost)  
	e2:SetTarget(cm.fliptg)  
	e2:SetOperation(cm.flipop)  
	c:RegisterEffect(e2) 
	--pos
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_POSITION)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCode(EVENT_PHASE+PHASE_END)  
	e3:SetCountLimit(1,m+10000)  
	e3:SetTarget(cm.postg)  
	e3:SetOperation(cm.posop)  
	c:RegisterEffect(e3)   
	--battle indestructable
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e4:SetValue(1) 
	e4:SetCondition(cm.effcon)  
	c:RegisterEffect(e4)  
end
function cm.chkop(e,tp,eg,ep,ev,re,r,rp)  
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)  
end  
function cm.flipcon(e,tp,eg,ep,ev,re,r,rp)  
	return rc~=e:GetHandler()
end  
function cm.flipcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return c:IsFacedown() end  
	local pos=Duel.SelectPosition(tp,c,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)  
	Duel.ChangePosition(c,pos)
end  
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0x6298) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))  
end  
function cm.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end  
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)  
	local tc=g:GetFirst()  
	if not tc then return end  
	local spos=0  
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) then spos=spos+POS_FACEUP_ATTACK end  
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then spos=spos+POS_FACEDOWN_DEFENSE end  
	if spos~=0 then  
		Duel.SpecialSummon(tc,0,tp,tp,false,false,spos)  
		if tc:IsFacedown() then  
			Duel.ConfirmCards(1-tp,tc)  
		end  
	end  
	local e3=Effect.CreateEffect(e:GetHandler())  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetTargetRange(1,0)  
	e3:SetTarget(function(e,c)  return not c:IsSetCard(0x6298)  end)  
	e3:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e3,tp)
end  
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)  
	local tc=e:GetHandler():GetBattleTarget()  
	return tc and tc:IsRelateToBattle()  
end  
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=e:GetHandler():GetBattleTarget()  
	Duel.Hint(HINT_CARD,0,m)  
	Duel.SendtoGrave(tc,REASON_EFFECT)  
end  
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsCanTurnSet() end  
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)  
end  
function cm.posop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and c:IsFaceup() then  
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)  
	end  
end  
function cm.effcon(e)  
	return e:GetHandler():GetFlagEffect(m)~=0  
end  