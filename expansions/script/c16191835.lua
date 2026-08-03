--幽静的心之辉 天憧澪
local s,id,o=GetID()
function s.initial_effect(c)
	--不用解放召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(s.ntcon)
	c:RegisterEffect(e1)
	--卡组检索
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--加入手卡
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(s.bhcon1)
    e4:SetCost(s.bhcost)
	e4:SetTarget(s.bhtg)
	e4:SetOperation(s.bhop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCondition(s.bhcon2)
	c:RegisterEffect(e5)   
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.thfilter(c)
	return c:IsSetCard(0x57b0) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local con
	if Duel.IsPlayerAffectedByEffect(tp,16191885) then
    	con=Duel.GetFlagEffect(tp,id)<2
    else
    	con=Duel.GetFlagEffect(tp,id)<1
    end
	if chk==0 then return con and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.bhcon1(e,tp,eg,ep,ev,re,r,rp)
	return not cor.IsCanBeQuickEffect(e:GetHandler(),tp,16191870)
end
function s.bhcon2(e,tp,eg,ep,ev,re,r,rp)
	return cor.IsCanBeQuickEffect(e:GetHandler(),tp,16191870)
end
function s.bhcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
    Duel.ConfirmCards(1-tp,e:GetHandler())
end
function s.bhfilter(c)
	return c:IsSetCard(0x57b0) and c:IsAbleToHand()
end
function s.bhtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local con
	if Duel.IsPlayerAffectedByEffect(tp,16191885) then
    	con=Duel.GetFlagEffect(tp,id+o)<2
    else
    	con=Duel.GetFlagEffect(tp,id+o)<1
    end
	if chk==0 then return con and Duel.IsExistingMatchingCard(s.bhfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
    Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.bhop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.bhfilter),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if sg:GetCount()>0 then 
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
            if Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))==0 then
				Duel.SendtoDeck(sg:GetFirst(),nil,0,REASON_EFFECT)
            else
            	Duel.SendtoDeck(sg:GetFirst(),nil,1,REASON_EFFECT)
            end    
		end
	end
end
--
Corflos={}
cor=Corflos
function Corflos.RanuticusFilter(c)
	return (c:IsLocation(LOCATION_MZONE) and c:IsAllTypes(TYPE_XYZ+TYPE_MONSTER) or c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER))
    	and c:IsOriginalSetCard(0x57b0)
end
function Corflos.IsCanBeQuickEffect(c,tp,code)
	return Duel.IsPlayerAffectedByEffect(tp,code)~=nil and Corflos.RanuticusFilter~=nil and Corflos.RanuticusFilter(c)
end