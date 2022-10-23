--晶化血裔 暗影伯爵德古拉
local s,id,o=GetID()
Duel.LoadScript("c33201050.lua")
function s.initial_effect(c)
	c:EnableCounterPermit(0x32b)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),8,2,s.ovfilter,aux.Stringid(id,0),99,XY_VHisc.xyzop,id)
	c:EnableReviveLimit()   
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.reptg)
	c:RegisterEffect(e2)
end
s.VHisc_Vampire=true

--xyz
function s.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and not c:IsCode(id)
end

--e1
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local atk=tc:GetBaseAttack()
		if atk>0 then 
			local rec=Duel.Recover(tp,atk,REASON_EFFECT)
			if rec>0 and e:GetHandler():IsCanRemoveCounter(tp,0x32b,4,REASON_EFFECT) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,2)) then
				e:GetHandler():RemoveCounter(tp,0x32b,4,REASON_EFFECT)
				Duel.RaiseEvent(e:GetHandler(),EVENT_REMOVE_COUNTER+0x32b,e,REASON_EFFECT,tp,tp,ev)
				Duel.Damage(1-tp,rec,REASON_EFFECT)
			end
		end
	end
end


--e2
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end