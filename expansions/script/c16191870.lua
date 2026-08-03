--盛放的心之辉 洋牡丹
local s,id,o=GetID()
function s.initial_effect(c)
	--超量召唤
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x57b0),5,2,nil,nil,99)
	c:EnableReviveLimit()
	--适用效果
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
--e1:SetCondition(s.efcon)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
	--控顶
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
	e2:SetCondition(s.tdcon1)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(s.tdcon2)
	c:RegisterEffect(e3)
	--抽卡    
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCondition(s.drcon)
	e4:SetCost(s.drcost)
	e4:SetTarget(s.drtg)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)
end
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if Duel.GetFlagEffect(tp,id)>0 then return end
    Duel.Hint(HINT_CARD,0,id)    
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	--通天塔标记   
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(id)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	--特召限制    
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
    local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function s.splimit(e,c)
	return not c:IsLevel(5) and c:IsLocation(LOCATION_HAND)
end
function s.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return not cor.IsCanBeQuickEffect(e:GetHandler(),tp,id)
end
function s.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return cor.IsCanBeQuickEffect(e:GetHandler(),tp,id)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 
    	and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=3 end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 
    	or Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)<3 then return end
    Duel.ConfirmDecktop(tp,3)
    Duel.ConfirmDecktop(1-tp,3)
    local g1=Duel.GetDecktopGroup(tp,3)
    local g2=Duel.GetDecktopGroup(1-tp,3)
    if g1:GetCount()>0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
    	Duel.BreakEffect()
        local ct1=g1:GetCount()
        local ct2=g2:GetCount()
        Duel.SortDecktop(tp,tp,ct1)
        Duel.SortDecktop(tp,1-tp,ct2)
        for i=1,ct1 do
    		if not Duel.SelectYesNo(tp,aux.Stringid(id,4)) then break end
        	local ctg1=Duel.GetDecktopGroup(tp,ct1)
    		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
        	local mvc1=ctg1:Select(tp,1,1,nil):GetFirst()
        	Duel.MoveSequence(mvc1,SEQ_DECKBOTTOM)
        	ct1=ct1-1
    	end	
    	for i=1,ct2 do
    		if not Duel.SelectYesNo(tp,aux.Stringid(id,6)) then break end
        	local ctg2=Duel.GetDecktopGroup(1-tp,ct2)
    		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
        	local mvc2=ctg2:Select(tp,1,1,nil):GetFirst()
        	Duel.MoveSequence(mvc2,SEQ_DECKBOTTOM)
        	ct2=ct2-1
    	end	
    end
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
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