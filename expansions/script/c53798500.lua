local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,id-4)
	--Pendulum Effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(s.pencost)
	e1:SetTarget(s.pentg)
	e1:SetOperation(s.penop)
	c:RegisterEffect(e1)
	--Monster Effect 1: Equip 5 from opponent's deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.eqcon)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
	--Monster Effect 2: Change opponent's effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.chcon)
	e3:SetTarget(s.chtg)
	e3:SetOperation(s.chop)
	c:RegisterEffect(e3)
end
function s.tgfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function s.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
		local ct=0
		while ct<3 do
			local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
			local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
			if not b1 and not b2 then break end
			if ct>0 and not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then break end
			local op=0
			if b1 and b2 then
				op=Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,5))
			elseif b1 then
				op=Duel.SelectOption(tp,aux.Stringid(id,4))
			else
				op=Duel.SelectOption(tp,aux.Stringid(id,5))+1
			end
			local ec=nil
			if op==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				ec=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
			else
				ec=Duel.GetDecktopGroup(tp,1):GetFirst()
			end
			if ec then
				Duel.DisableShuffleCheck()
				if ec:IsForbidden() then
					Duel.SendtoGrave(ec,REASON_RULE)
				else
					Duel.Equip(tp,ec,tc,false,true)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_EQUIP_LIMIT)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(s.eqlimit)
					e1:SetLabelObject(tc)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					ec:RegisterEffect(e1)
				end
			end
			ct=ct+1
		end
		if ct>0 then
			Duel.EquipComplete()
		end
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end

function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.sfilter(c)
	return c:GetSequence()<5
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetDecktopGroup(1-tp,5)
	if g:GetCount()<5 then return end
	local dg=Duel.GetMatchingGroup(s.sfilter,1-tp,LOCATION_SZONE,0,nil)
	if dg:GetCount()>0 then
		Duel.Destroy(dg,REASON_RULE)
	end
	local sg=Group.CreateGroup()
	for tc in aux.Next(g) do
		Duel.DisableShuffleCheck()
		if tc:IsForbidden() then
			Duel.SendtoGrave(tc,REASON_RULE)
		else
			Duel.Equip(1-tp,tc,c,false,true)
			sg:AddCard(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(c)
			e1:SetValue(s.eqlimit)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetValue(500)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
	Duel.EquipComplete()
	if #sg>1 then Duel.ShuffleSetCard(sg) end
end

function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function s.repfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand() and c:GetEquipTarget()
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.repfilter,1-tp,LOCATION_SZONE,0,1,nil) end
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(1-tp,s.repfilter,tp,LOCATION_SZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local eqc=tc:GetEquipTarget()
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) 
			and c:IsRelateToEffect(e) 
			and eqc and eqc:IsLocation(LOCATION_MZONE) and eqc:IsFaceup() then
			if Duel.Equip(tp,c,eqc) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(s.eqlimit)
				e1:SetLabelObject(eqc)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1)
			end
		end
	end
end
