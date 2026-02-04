--半魔的赤鬼
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
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
	
	--return to hand (spell/trap) (ignition)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(aux.NOT(s.thcon))
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	--return to hand (spell/trap) (quick)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(s.thcon)
	c:RegisterEffect(e4)
end

function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(function(c) return c:IsSetCard(0x3f50) and c:IsControler(tp) end,1,nil) 
end

function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at and at:IsFaceup() and at:IsControler(tp) and at:IsSetCard(0x3f50)
end

function s.otfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3f50) and c:IsRace(RACE_FIEND+RACE_SPELLCASTER) and not c:IsCode(id)
end

function s.getcolumn(c)
	if c:IsLocation(LOCATION_MZONE) then
		return c:GetSequence()
	else
		return c:GetPreviousSequence()
	end
end

function s.thfilter1(c,seq)
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
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_MZONE)
	end
end

function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if Duel.IsExistingMatchingCard(s.otfilter,tp,LOCATION_MZONE,0,1,c) then
			local axis_g=Duel.GetMatchingGroup(function(target)
				if not (target:IsFaceup() and target:IsSetCard(0x3f50)) then return false end
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
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
						local sg=dg:Select(tp,1,1,nil)
						Duel.SendtoHand(sg,nil,REASON_EFFECT)
					end
				end
			end
		end
	end
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.thconfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.thconfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3f50) and not c:IsCode(id)
end

function s.thfilter(c)
	return c:IsSetCard(0x3f50) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then 
		return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil)
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end