--天墜星隕
local s,id,o=GetID()
function s.initial_effect(c)
    --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
    --Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1,id)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsAbleToHand,tp,0x04,0x04,nil)>0 end
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
    e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
end
function s.Check(c,tp)
    return c:IsLocation(0x02) and c:IsSetCard(0x540b)
        and c:IsPreviousControler(tp)
end
function s.desfi1ter(c,pl,seq)
	local sseq=c:GetSequence()
	if c:IsControler(pl) then
		return sseq==5 and seq==3 or sseq==6 and seq==1
	end
	if c:IsLocation(LOCATION_SZONE) then
		return sseq<5 and sseq==seq
	end
	if sseq<5 then
		return (seq==6 and sseq==3) or (seq==5 and sseq==1)
            or sseq==seq+1 or sseq==seq-1
	end
	if sseq>=5 then
		return sseq==5 and seq==1 or sseq==6 and seq==3
	end
end
function s.desfi2ter(c,seq)
	local sseq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then
		return sseq<5 and sseq==seq
	end
	if sseq<5 then
		return sseq==seq+1 or sseq==seq-1
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0x04,0x04,nil)
    if #g>0 then
        Duel.Hint(3,tp,505)
        local sg=g:Select(tp,1,1,nil)
        Duel.HintSelection(sg)
        local sc=sg:GetFirst()
        if Duel.SendtoHand(sc,nil,0x40)>0 and s.Check(sc,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
            local tc=re:GetHandler()
            local dg=Group.CreateGroup()
            if tc:IsRelateToEffect(re) then
                dg:AddCard(tc)
                if tc:IsLocation(0x0c) and not tc:IsLocation(LOCATION_FZONE) then
                    local pl=tp
                    if tc:GetControler()==tp then pl=1-pl end
                    if tc:IsLocation(0x04) and tc:GetSequence()<5 then
		                local cg=Duel.GetMatchingGroup(s.desfi1ter,pl,0x04,0x0c,tc,pl,tc:GetSequence())
                        dg:Merge(cg)
                    elseif tc:IsLocation(0x08) and tc:GetSequence()<5 then
                        local cg=Duel.GetMatchingGroup(s.desfi2ter,pl,0,0x0c,tc,tc:GetSequence())
                        dg:Merge(cg)
                    elseif tc:IsLocation(0x04) and tc:GetSequence()>4 then
                        local cg=tc:GetColumnGroup():Filter(Card.IsLocation,nil,0x04)
                        dg:Merge(cg)
                    end
                end
            end
            if Duel.NegateActivation(ev) and #dg>0 then
                Duel.Destroy(dg,0x40)
            end
        end
	end
end