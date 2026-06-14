--风翼妖蛇 埃埃卡特尔
local s,id=GetID()
function s.DarkSnake(c)
	local m = _G["c"..c:GetCode()]
	if m and m.named_with_DarkSnake then return true end
	if c:GetCode() == 40020764 and c:IsLocation(LOCATION_PZONE) then return true end
	return false
end
s.named_with_DarkSnake=1
function s.initial_effect(c)
		aux.AddCodeList(c,40020764)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.matfilter,2,2)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tg1)
	e2:SetOperation(s.op1)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.tg2)
	e3:SetOperation(s.op2)
	c:RegisterEffect(e3)
end
function s.matfilter(c)
	return s.DarkSnake(c)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetTurnPlayer()~=tp
end

function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end

function s.tgfilter(c)
	return c:IsAbleToGrave()
end

function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)>0 then
		if Duel.IsExistingMatchingCard(s.tgfilter,tp,0,LOCATION_ONFIELD,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
			if #sg>0 then
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
	end
end

function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,40020764)
	local b2=false
	if not b1 then
		local ct1=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_EXTRA,0,nil,40020764)
		local ct2=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,40020764)
		if ct1+ct2>=3 then
			b2=Duel.IsExistingMatchingCard(s.DarkSnake,tp,LOCATION_GRAVE,0,1,nil)
		end
	end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and (chkc:IsCode(40020764) or (b2 and s.DarkSnake(chkc))) end
	if chk==0 then return b1 or b2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g
	if b1 then
		g=Duel.SelectTarget(tp,Card.IsCode,tp,LOCATION_GRAVE,0,1,1,nil,40020764)
	else
		g=Duel.SelectTarget(tp,s.DarkSnake,tp,LOCATION_GRAVE,0,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local canSummon=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local zone0=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local zone2=Duel.GetFieldCard(tp,LOCATION_PZONE,2)
	local canPlace=(zone0==nil or zone2==nil) and tc:IsType(TYPE_PENDULUM)
	local op=nil
	if canSummon and canPlace then
		op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
	elseif canSummon then
		op=0
	elseif canPlace then
		op=1
	else
		return
	end
	if op==0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		local seq
		local avail=0
		if zone0==nil then avail=avail|1 end
		if zone2==nil then avail=avail|4 end
		if avail==5 then
			local flag=Duel.SelectField(tp,1,LOCATION_PZONE,0,0)
			seq=math.log(flag,2)
		elseif avail==1 then
			seq=0
		else
			seq=2
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true,1<<seq)
	end
end