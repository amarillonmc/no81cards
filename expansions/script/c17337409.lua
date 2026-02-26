--半魔的青鬼
local s,id,o=GetID()
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
		if not (c:IsControler(tp) and c:IsSetCard(0x3f50)) then return false end
		if c:IsLocation(LOCATION_ONFIELD) then
			return c:IsFaceup()
		end
		return c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsFaceupEx()
	end,1,nil)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at and at:IsFaceup() and at:IsControler(tp) and at:IsSetCard(0x3f50)
end
function s.otfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3f50) and c:IsRace(RACE_FIEND+RACE_WARRIOR) and not c:IsCode(id)
end
function s.getcolumn(c)
	if c:IsLocation(LOCATION_MZONE) then
		return c:GetSequence()
	else
		return c:GetPreviousSequence()
	end
end
function s.desfilter(c,seq)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:GetSequence()==seq
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local res=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		if not res then return false end
		return true
	end	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local b=Duel.IsExistingMatchingCard(s.otfilter,tp,LOCATION_MZONE,0,1,nil)
	if b then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
	end
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
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
				local sel=axis_g:Select(tp,1,1,nil):GetFirst()
				if sel then
					Duel.HintSelection(Group.FromCards(sel))
					local dg=sel:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
					if #dg>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
						local sg=dg:Select(tp,1,1,nil)
						Duel.Destroy(sg,REASON_EFFECT)
					end
				end
			end
		end
	end
end
function s.thfilter(c)
	return c:IsSetCard(0x3f50) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFaceupEx()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then 
		return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil)
	end	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end