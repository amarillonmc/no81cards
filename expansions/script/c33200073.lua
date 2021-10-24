--铁战灵兽 M波士可多拉
function c33200073.initial_effect(c)
	aux.AddCodeList(c,33200071) 
	--spesm
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x322),9,99,c33200073.ovfilter,aux.Stringid(33200073,0),99,c33200073.xyzop)
	c:EnableReviveLimit()   
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c33200073.disable)
	e1:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e1) 
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetValue(c33200073.indct)
	c:RegisterEffect(e2) 
	--battle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200073,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c33200073.bacost)
	e3:SetTarget(c33200073.batg)
	e3:SetOperation(c33200073.baop)
	c:RegisterEffect(e3)
end

--xyz
function c33200073.ovfilter(c)
	return c:IsFaceup() and c:IsCode(33200071)
end
function c33200073.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x323)
end
function c33200073.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,33200052)==0
	and Duel.IsExistingMatchingCard(c33200073.xyzfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.RegisterFlagEffect(tp,33200052,nil,EFFECT_FLAG_OATH,1)
end

--e1
function c33200073.disable(e,c)
	local seq=aux.MZoneSequence(c:GetSequence())
	return Duel.IsExistingMatchingCard(c33200073.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,seq)
end
function c33200073.cfilter(c,seq2)
	local seq1=aux.MZoneSequence(c:GetSequence())
	return c:IsFaceup() and c:IsSetCard(0x322) and seq1==4-seq2
end

--e2
function c33200073.indct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end

--e3
function c33200073.bacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33200073.batg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return c:IsAttackable()
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end
function c33200073.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackable() and c:IsControler(tp) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local tc=g:GetFirst()
		if tc:IsControler(1-tp) and tc:IsRelateToEffect(e) then
			Duel.CalculateDamage(c,tc)
		end
	end
end