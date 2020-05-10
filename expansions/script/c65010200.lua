--『怪盗Hello Happy』 濑田薰
function c65010200.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	 --spsummon bgm
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c65010200.sumcon)
	e0:SetOperation(c65010200.sumsuc)
	c:RegisterEffect(e0)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65010200,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c65010200.eqcon)
	e1:SetCost(c65010200.eqcost)
	e1:SetTarget(c65010200.eqtg)
	e1:SetOperation(c65010200.eqop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c65010200.desreptg)
	e2:SetValue(c65010200.desrepval)
	e2:SetOperation(c65010200.desrepop)
	c:RegisterEffect(e2)
end
function c65010200.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c65010200.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(65010200,0))
end
function c65010200.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c65010200.desrepfil(c)
	return c:GetEquipTarget()~=nil and c:IsAbleToGrave()
end
function c65010200.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c65010200.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c65010200.desrepfil,tp,LOCATION_SZONE,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c65010200.desrepval(e,c)
	return c65010200.repfilter(c,e:GetHandlerPlayer())
end
function c65010200.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65010200)
	local g=Duel.SelectMatchingCard(tp,c65010200.desrepfil,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
end
function c65010200.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c65010200.can_equip_monster(c)
end
function c65010200.eqfilter(c)
	return c:GetFlagEffect(65010200)~=0 
end
function c65010200.can_equip_monster(c)
	local g=c:GetEquipGroup():Filter(c65010200.eqfilter,nil)
	return g:GetCount()==0
end
function c65010200.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c65010200.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_EXTRA,nil)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c65010200.eqlimit(e,c)
	return e:GetOwner()==c
end
function c65010200.equip_monster(c,tp,tc)
	Duel.ConfirmCards(tp,tc)
	if not Duel.Equip(tp,tc,c,true) then return end
	local code=tc:GetCode()
	--Add Equip limit
	tc:RegisterFlagEffect(65010200,RESET_EVENT+RESETS_STANDARD,0,0)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	e0:SetValue(c65010200.eqlimit)
	tc:RegisterEffect(e0)
	--copy
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)   
end
function c65010200.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ag=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_EXTRA,nil)
	if ag:GetCount()<3 then return end
	local g=ag:RandomSelect(1-tp,3)
	Duel.ConfirmCards(tp,g)
	if g:IsExists(Card.IsAbleToChangeControler,1,nil) then
		local sg=g:Filter(Card.IsAbleToChangeControler,1,nil)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		c65010200.equip_monster(c,tp,tc)
	end
end