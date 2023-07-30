--食恶餐厨鬼
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2,s.ovfilter,aux.Stringid(id,0),2,s.xyzop)
	c:EnableReviveLimit()
	--Overlay
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.ovcon)
	e1:SetTarget(s.ovtg)
	e1:SetOperation(s.ovop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.iumcon)
	e2:SetOperation(s.iumop)
	c:RegisterEffect(e2)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	e3:SetCondition(s.xcon)
	c:RegisterEffect(e3)
	--
	if not s.globle_check then
		s.globle_check=true
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetCondition(s.XyzConditionAlter)
		e1:SetTarget(s.XyzTargetAlter)
		e1:SetOperation(s.XyzOperationAlter)
		e1:SetValue(SUMMON_TYPE_XYZ)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e2:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,55727845))
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,0)
	end
end
function s.xcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsCode(55727845)
end
function s.iumcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.iumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,4)) then
		Duel.Hint(HINT_CARD,0,id)
		c:RemoveOverlayCard(tp,1,1,REASON_COST)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.efilter)
		e1:SetLabelObject(re)
		c:RegisterEffect(e1)
	end
end
function s.efilter(e,te)
	return te==e:GetLabelObject()
end
function s.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.ofilter(c,e)
	return c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e)) and c:IsLevel(2) and c:IsRace(RACE_FIEND)
end
function s.mtfilter(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(s.ofilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(s.ofilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(s.ofilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function s.gcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)==1
		and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)==1
		and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==1
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	if not (Duel.IsExistingMatchingCard(s.ofilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(s.ofilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.ofilter),tp,LOCATION_GRAVE,0,1,nil)) then return false end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.ofilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if c:IsRelateToEffect(e) or #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:SelectSubGroup(tp,s.gcheck,false,3,3)
		if sg and #sg>0 then
			Duel.Overlay(c,sg)
			local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.mtfilter),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,e)
			local ct=c:GetOverlayGroup():FilterCount(Card.IsSetCard,nil,0x8b)
			if ct>0 and #mg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local xg=mg:Select(tp,1,ct,nil)
				local tc1=xg:GetFirst()
				while tc1 do
					tc1:CancelToGrave()
					local og=tc1:GetOverlayGroup()
					if #og>0 then
						Duel.SendtoGrave(og,REASON_RULE)
					end
					tc1=xg:GetNext()
				end
				Duel.Overlay(c,xg)
			end
			if sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)>0 then
				Duel.ShuffleDeck(tp)
			end
		end
	end
end

--Xyz summon(alterf)
function s.XyzConditionAlter(e,c,og)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	end
	return mg:IsExists(s.ovfilter2,1,nil)
end
function s.XyzTargetAlter(e,tp,eg,ep,ev,re,r,rp,chk,c,og)
	local mg=nil
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	end
	local g=nil
	if mg:IsExists(s.ovfilter2,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,s.ovfilter2,1,1,nil)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	else return false end
end
function s.XyzOperationAlter(e,tp,eg,ep,ev,re,r,rp,c,og)
	local mg=e:GetLabelObject()
	local mg2=mg:GetFirst():GetOverlayGroup()
	if mg2:GetCount()~=0 then
		Duel.Overlay(c,mg2)
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	mg:DeleteGroup()
end
function s.ovfilter2(c)
	return c:IsFaceup() and c:GetOriginalCodeRule()==id
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8b)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
