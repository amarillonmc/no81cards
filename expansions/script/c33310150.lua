--引临魔源 地侧之月
function c33310150.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--xyz
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(c33310150.xcon)
	e1:SetTarget(c33310150.xtg)
	e1:SetOperation(c33310150.xop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,33310150)
	e2:SetTarget(c33310150.thtg)
	e2:SetOperation(c33310150.thop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(c33310150.target)
	e3:SetValue(c33310150.indct)
	c:RegisterEffect(e3)
end
function c33310150.target(e,c)
	return c:IsSetCard(0x55b)
end
function c33310150.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end

function c33310150.xconfil(c,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x55b) and c:GetSummonPlayer()==tp 
end
function c33310150.xcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(c33310150.xconfil,nil,tp)==1
end
function c33310150.xtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_GRAVE,LOCATION_GRAVE)>0 end
	Duel.SetTargetCard(eg)
end
function c33310150.xop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local egg=eg:Filter(c33310150.xconfil,nil,tp)
	local tc=egg:GetFirst()
	if tc and tc:IsRelateToEffect(e) and tc:IsType(TYPE_XYZ) and tc:IsFaceup() then
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		if g then
			Duel.HintSelection(g)
			local lab=0
			if g:GetFirst():IsLocation(LOCATION_HAND) then lab=1 end
			Duel.Overlay(tc,g)
			if lab==1 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(33310150,0)) then
				local g2=Duel.GetDecktopGroup(tp,1)
				Duel.Overlay(tc,g2)
			end
		end
	end
end

function c33310150.thtgfil(c)
	return c:IsSetCard(0x55b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33310150.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33310150.thtgfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33310150.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c33310150.thtgfil,tp,LOCATION_DECK,0,1,1,nil)
	if g then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end