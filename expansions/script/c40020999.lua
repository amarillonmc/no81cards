--动气输送机 鹈鹕运输机
local s,id=GetID()
s.named_with_DrivenForce=1

function s.DrivenForce(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_DrivenForce
end

function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end

function s.initial_effect(c)
	aux.AddCodeList(c,40020585)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon1)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id) 
	e2:SetCondition(s.spcon2)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_XYZ_LEVEL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.xyzlv)
	e3:SetLabel(2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetLabel(6)
	c:RegisterEffect(e4)
end

function s.yamatofilter(c)
	return c:IsCode(40020585) and c:IsFaceup()
end

function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.yamatofilter,tp,LOCATION_PZONE+LOCATION_EXTRA,0,1,nil)
end

function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsPreviousLocation(LOCATION_DECK) and re) then return false end
	local rc=re:GetHandler()
	return rc and s.Grandwalker(rc)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.thfilter(c)
	return s.DrivenForce(c) and c:IsType(TYPE_TRAP) and (c:IsAbleToHand() or c:IsSSetable())
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			if tc then
				local b1=tc:IsAbleToHand()
				local b2=tc:IsSSetable()
				local op=0
				if b1 and b2 then
					op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
				elseif b1 then
					op=0
				else
					op=1
				end
				if op==0 then
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				else
					Duel.SSet(tp,tc)
				end
			end
		end
	end
end

function s.xyzlv(e,c,rc)
	local lv=c:GetLevel()
	if rc:IsAttribute(ATTRIBUTE_WATER+ATTRIBUTE_WIND) then
		return lv + 0x10000 * e:GetLabel()
	else
		return lv
	end
end
