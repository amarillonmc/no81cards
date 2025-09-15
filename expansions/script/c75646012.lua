--崩崩学园 伊瑟琳
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetValue(s.matval)
	c:RegisterEffect(e1)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,id-70000000)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.tgcost)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.chaincon)
	e4:SetOperation(s.chainop)
	c:RegisterEffect(e4)
end
function s.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(id)
end
function s.matval(e,lc,mg,c,tp)
	if not lc:IsSetCard(0x2c0,0x2c5,0xc2c3)  then return false,nil end
	return true,not mg or not mg:IsExists(s.exmfilter,1,nil)
end
function s.cfilter(c)
	if c:IsLocation(LOCATION_GRAVE) then return c:IsAbleToRemoveAsCost() and c:IsHasEffect(75646628,tp) end
	return (aux.IsCodeListed(c,75646600) or (c:IsSetCard(0x2c0) and c:IsType(TYPE_EQUIP))) and c:IsAbleToGraveAsCost()
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	local te=tc:IsHasEffect(75646628,tp)
	if te then
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
	else
		if tc:IsCode(75646600) then e:SetLabel(1) end
		Duel.SendtoGrave(tc,REASON_COST)
	end
end
function s.tgfilter(c)
	return (aux.IsCodeListed(c,75646600) or c:IsSetCard(0x2c0)) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local rg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0x7f,0,nil,75646600)
	if rg:GetCount()>0 then
		local rc=rg:GetFirst()
		while rc do
			if rc:GetFlagEffect(5646600)<15 then
				rc:RegisterFlagEffect(5646600,0,0,0)
			end
			rc:ResetFlagEffect(646600)
			rc:RegisterFlagEffect(646600,0,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(75646600,rc:GetFlagEffect(5646600)))
			rc=rg:GetNext()
		end
	end
end
function s.chaincon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	local es=re:GetHandler()
	if es:IsSetCard(0x2c0) and es:IsType(TYPE_EQUIP) and es:GetEquipTarget()==e:GetHandler() and ep==tp then
		if Duel.IsPlayerAffectedByEffect(e:GetHandler():GetControler(),75646210) then
			Duel.SetChainLimit(s.chainlm)
		else
			Duel.SetChainLimit(aux.FALSE)
		end  
	end
end
function s.chainlm(e,rp,tp)
	return tp==rp
end