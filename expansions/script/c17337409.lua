--半魔的青鬼
local s,id=GetID()
function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon1)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)
	
	local e2=e1:Clone()
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCondition(s.spcon2)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end

function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(function(c)
		return c:IsControler(tp) and c:IsSetCard(0x3f50) and c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
	end,1,nil)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at and at:IsFaceup() and at:IsControler(tp) and at:IsSetCard(0x3f50)
end

function s.otfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3f50) and c:IsRace(RACE_FIEND+RACE_WARRIOR)
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
	end	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if Duel.IsExistingMatchingCard(s.otfilter,tp,LOCATION_MZONE,0,1,c) then
			local axis_g=Duel.GetMatchingGroup(function(target)
				if not (target:IsFaceup() and (target:IsSetCard(0x3f50) or target:IsCode(17337435))) then return false end
				local dg=target:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
				return #dg>0
			end,tp,LOCATION_MZONE,0,nil)
			if #axis_g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3)) 
				local sel=axis_g:Select(tp,1,1,nil):GetFirst()
				if sel then
					Duel.HintSelection(Group.FromCards(sel))
					local dg=sel:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
					if #dg>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
						local sg=dg:Select(tp,1,1,nil)
						Duel.HintSelection(sg) 
						Duel.Destroy(sg,REASON_EFFECT)
					end
				end
			end
		end
	end
end

function s.thfilter(c)
	return c:IsSetCard(0x3f50) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then 
		return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil)
	end	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end