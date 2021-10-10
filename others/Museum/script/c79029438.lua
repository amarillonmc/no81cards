--炎国·特种干员-乌有
function c79029438.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,79029438)
	e1:SetCost(c79029438.sprcost)
	e1:SetTarget(c79029438.sprtg)
	e1:SetOperation(c79029438.sprop)
	c:RegisterEffect(e1)  
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19029438)
	e2:SetTarget(c79029438.desreptg)
	e2:SetValue(c79029438.desrepval)
	e2:SetOperation(c79029438.desrepop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c79029438.discon)
	e3:SetCost(c79029438.discost)
	e3:SetTarget(c79029438.distg)
	e3:SetOperation(c79029438.disop)
	c:RegisterEffect(e3)
end
c79029438.toss_coin=true
function c79029438.sprfilter(c)
	return c:IsSetCard(0xa900) and c:IsAbleToGraveAsCost() 
end
function c79029438.sprcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SUMMON)
	local b2=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)
	local b3=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE) 
	if chk==0 then return Duel.IsExistingMatchingCard(c79029438.sprfilter,tp,LOCATION_HAND,0,1,nil) and (b1 or b2 or b3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029438.sprfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029438.sprtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  end
end
function c79029438.sprop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SUMMON)
	local b2=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)
	local b3=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE) 
	local op=0
	if b1 and b2 and b3 then
	op=Duel.SelectOption(tp,aux.Stringid(79029438,0),aux.Stringid(79029438,1),aux.Stringid(79029438,2))
	elseif b1 and b2 then
	op=Duel.SelectOption(tp,aux.Stringid(79029438,0),aux.Stringid(79029438,1))
	elseif b1 and b3 then
	op=Duel.SelectOption(tp,aux.Stringid(79029438,0),aux.Stringid(79029438,3))
	if op==1 then 
	op=op+1
	end
	elseif b2 and b3 then
	op=Duel.SelectOption(tp,aux.Stringid(79029438,1),aux.Stringid(79029438,2))+1
	elseif b1 then
	op=Duel.SelectOption(tp,aux.Stringid(79029438,0))
	elseif b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(79029438,1))+1
	elseif b3 then  
	op=Duel.SelectOption(tp,aux.Stringid(79029438,2))+2
	end
	if op==0 then
	xe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SUMMON)
	elseif op==1 then
	xe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)
	elseif op==2 then
	xe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)
	end	 
	Debug.Message("好嘞，博士您就放一百个心吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029438,8))
	xe:Reset()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.SelectYesNo(tp,aux.Stringid(79029438,3)) then 
	Debug.Message("好嘞，交给我吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029438,9))
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c79029438.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c79029438.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c79029438.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c79029438.desrepval(e,c)
	return c79029438.repfilter(c,e:GetHandlerPlayer())
end
function c79029438.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ts=Duel.TossCoin(tp,1)
	if ts==1 then
	Debug.Message("炉火纯青，当收放自如。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029438,10))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)		
	else
	Debug.Message("月有阴晴，扇有开合。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029438,11))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	end
	Duel.Hint(HINT_CARD,0,79029438)
	if Duel.IsPlayerCanDraw(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(79029438,7))
 then
	Debug.Message("不愧是博士，英明的决断！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029438,13))
	Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function c79029438.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c79029438.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_SUMMON)
	local b2=Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_SPECIAL_SUMMON)
	local b3=Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_ACTIVATE)
	if chk==0 then return (b1 or b2 or b3) and c:IsDiscardable() end 
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	local op=0
	if b1 and b2 and b3 then
	op=Duel.SelectOption(tp,aux.Stringid(79029438,4),aux.Stringid(79029438,5),aux.Stringid(79029438,6))
	elseif b1 and b2 then
	op=Duel.SelectOption(tp,aux.Stringid(79029438,4),aux.Stringid(79029438,5))
	elseif b1 and b3 then
	op=Duel.SelectOption(tp,aux.Stringid(79029438,4),aux.Stringid(79029438,6))
	if op==1 then 
	op=op+1
	end
	elseif b2 and b3 then
	op=Duel.SelectOption(tp,aux.Stringid(79029438,5),aux.Stringid(79029438,6))+1
	elseif b1 then
	op=Duel.SelectOption(tp,aux.Stringid(79029438,4))
	elseif b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(79029438,5))+1
	elseif b3 then  
	op=Duel.SelectOption(tp,aux.Stringid(79029438,6))+2
	end
	if op==0 then
	xe=Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_SUMMON)
	elseif op==1 then
	xe=Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_SPECIAL_SUMMON)
	elseif op==2 then
	xe=Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_ACTIVATE)
	end	 
	xe:Reset()
end
function c79029438.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c79029438.disop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("气定，神闲。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029438,12))
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
	end
end















