--缄守的心之辉 倒吊兰
local s,id,o=GetID()
function s.initial_effect(c)
	--超量召唤
	aux.AddXyzProcedure(c,nil,5,2,nil,nil,99)
	c:EnableReviveLimit()
	--适用效果
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.efcon)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
	--盲堆    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.tgcon1)
    e2:SetCost(s.tgcost)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(s.tgcon2)
	c:RegisterEffect(e3)
	--破坏    
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_ANNOUNCE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.descon)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
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
	--双破耐性    
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.indtg)
    e1:SetValue(s.indct)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function s.indtg(e,c)
	return c:IsSetCard(0x57b0)
end
function s.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function s.tgcon1(e,tp,eg,ep,ev,re,r,rp)
	return not cor.IsCanBeQuickEffect(e:GetHandler(),tp,16191870)
    	and e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x57b0)
end
function s.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	return cor.IsCanBeQuickEffect(e:GetHandler(),tp,16191870)
    	and e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x57b0)
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:GetHandler():IsRelateToEffect(re)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local con
	if Duel.IsPlayerAffectedByEffect(tp,16191885) then
    	con=Duel.GetFlagEffect(tp,id+o)<2
    else
    	con=Duel.GetFlagEffect(tp,id+o)<1
    end
	if chk==0 then return con and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
    Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
    if rc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 
    	and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
    	Duel.ConfirmDecktop(tp,1)
		local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
    	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
        if tc:IsCode(ac) and Duel.IsChainDisablable(ev) then
        	Duel.BreakEffect()
            Duel.NegateEffect(ev)
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