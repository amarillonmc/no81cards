--引临魔源 时械之塔
function c33310151.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33310151.tg)
	e1:SetOperation(c33310151.op)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,33310151)
	e2:SetTarget(c33310151.thtg)
	e2:SetOperation(c33310151.thop)
	c:RegisterEffect(e2)
end
function c33310151.thtgfil(c)
	return c:IsSetCard(0x55b) and c:IsAbleToHand()
end
function c33310151.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33310151.thtgfil,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c33310151.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c33310151.thtgfil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c33310151.b1gfil(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x55b)
end
function c33310151.raop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsLocation(LOCATION_MZONE) then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65050216,e,0,tp,0,0)
	end
end
function c33310151.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c33310151.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk) and c:IsRace(RACE_FAIRY)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c33310151.filter2(c,e,tp,mc,rk)
	return c:IsRank(rk+1) and c:IsSetCard(0x55b) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c33310151.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1g=Duel.GetMatchingGroup(c33310151.b1gfil,tp,LOCATION_MZONE,0,1,nil)
	local b1gc=b1g:GetFirst()
	local b1gg=Group.CreateGroup()
	while b1gc do
		b1gg:Merge(b1gc:GetOverlayGroup())
		b1gc=b1g:GetNext()
	end
	local b1=b1gg:FilterCount(Card.IsAbleToHand,nil)>0
	local b2=Duel.IsExistingMatchingCard(c33310151.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=999
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(33310151,0),aux.Stringid(33310151,1))
	elseif b1 then
		op=0
	elseif b2 then
		op=1
	end
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_OVERLAY)
	elseif op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(33310151,op))
	e:SetLabel(op)
end
function c33310151.op(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local b1g=Duel.GetMatchingGroup(c33310151.b1gfil,tp,LOCATION_MZONE,0,1,nil)
		local b1gc=b1g:GetFirst()
		local b1gg=Group.CreateGroup()
		while b1gc do
			b1gg:Merge(b1gc:GetOverlayGroup())
			b1gc=b1g:GetNext()
		end
		if b1gg:FilterCount(Card.IsAbleToHand,nil)>0 then
			local g=b1gg:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==1 then
		local g=Duel.SelectMatchingCard(tp,c33310151.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		if g then
			Duel.HintSelection(g)
			local tc=g:GetFirst()
			local rk=tc:GetRank()
			local g2=Duel.SelectMatchingCard(tp,c33310151.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,rk)
			local sc=g2:GetFirst()
			if sc then
				local mg=tc:GetOverlayGroup()
				if mg:GetCount()~=0 then
					Duel.Overlay(sc,mg)
				end
				sc:SetMaterial(Group.FromCards(tc))
				Duel.Overlay(sc,Group.FromCards(tc))
				Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
				sc:CompleteProcedure()
			end
		end
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
