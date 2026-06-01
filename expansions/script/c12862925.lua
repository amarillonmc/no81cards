--晴空光行·林间诗篇
local s,id,o=GetID()
function s.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(1118)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetOperation(s.riseop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    if not s.hack_check then
        s.hack_check = true
        s.check_act_Hand={false,false}
        _ori_hastype = Effect.IsHasType
        _ori_gettype = Effect.GetType
        _ori_getchaininfo = Duel.GetChainInfo
        gmskip=Duel.SkipPhase
        function Duel.SkipPhase(player,...)
            player=Duel.GetTurnPlayer()
			return gmskip(player,...)
		end
    end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    return rc:GetOriginalType()==TYPE_SPELL or rc:IsSetCard(0x5a76) and bit.band(rc:GetOriginalType(),TYPE_SPELL+TYPE_TRAP)~=0 or rc:IsCode(11451827)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        c:RegisterFlagEffect(12862905,RESET_EVENT+RESETS_STANDARD-RESET_REMOVE-RESET_LEAVE-RESET_TEMP_REMOVE,0,1)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x47e0000)
        e1:SetValue(LOCATION_REMOVED)
        c:RegisterEffect(e1,true) 
    end
end
function s.riseop(e,tp,eg,ep,ev,re,r,rp)
    if s.check_act_Hand[tp+1] == true then return end
    s.check_act_Hand[tp+1]=true
    if Duel.GetCurrentChain()>0 then
        local c=e:GetHandler()
        local rse=Effect.CreateEffect(c)
        rse:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
        rse:SetCode(EVENT_CHAIN_END)
        rse:SetOperation(s.rseop)
        Duel.RegisterEffect(rse,tp)
    else
        s.rseop(e,tp,eg,ep,ev,re,r,rp)
    end
end
function s.filter1(c,e,tp,eg,ep,ev,re,r,rp)
  if c:GetType()~=TYPE_SPELL then return false end
  local te_tab={c:GetActivateEffect()}
    for _,te in ipairs(te_tab) do
        local cond=te:GetCondition() or aux.TRUE
        local cost=te:GetCost() or aux.TRUE
        local tg=te:GetTarget()
        if tg==nil then tg=aux.TRUE end
        if cond(te,tp,eg,ep,ev,re,r,rp) and cost(te,tp,eg,ep,ev,re,r,rp,0) and tg(te,tp,eg,ep,ev,re,r,rp,0) then
            return true
        end
    end
    return false
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
    return re==e:GetLabelObject()
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
    e:GetLabelObject():GetHandler():CancelToGrave(false)
end
function s.resolvecost(f)
    return   function(e,tp,eg,ep,ev,re,r,rp,chk)
        if chk == 0 then return f(e,tp,eg,ep,ev,re,r,rp,chk) end
        Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        e:GetHandler():CreateEffectRelation(e)
        local rse=Effect.CreateEffect(e:GetHandler())
        rse:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        rse:SetCode(EVENT_CHAIN_NEGATED)
        rse:SetLabelObject(e)
        rse:SetCondition(s.regcon)
        rse:SetOperation(s.regop)
        rse:SetReset(RESET_CHAIN)
        Duel.RegisterEffect(rse,tp)

        function Effect.GetType(effect)
            if effect==e then
                return _ori_gettype(effect)|EFFECT_TYPE_ACTIVATE
            else
                return _ori_gettype(effect)
            end
        end

        function Effect.IsHasType(effect,type)
            if effect==e and type&EFFECT_TYPE_ACTIVATE>0 then
                return _ori_hastype(effect,type) or true
            else
                return _ori_hastype(effect,type)
            end
        end

        function Duel.GetChainInfo(chainc, ...)
            local tab = {}
            local param={...}
            for _,info in ipairs(param) do
                if _ori_getchaininfo(chainc, CHAININFO_TRIGGERING_EFFECT)==e then
                    if info == CHAININFO_TRIGGERING_LOCATION then
                        table.insert(tab, LOCATION_SZONE)
                    elseif info == CHAININFO_TRIGGERING_SEQUENCE then
                        table.insert(tab, e:GetHandler():GetSequence())
                    else
                        table.insert(tab, _ori_getchaininfo(chainc,info))
                    end
                else
                    table.insert(tab, _ori_getchaininfo(chainc,info))
                end
            end
            return table.unpack(tab)
        end

        f(e,tp,eg,ep,ev,re,r,rp,chk)
    end
end
function s.resolveoperation(f)
    return    function(e,tp,eg,ep,ev,re,r,rp)
                        f(e,tp,eg,ep,ev,re,r,rp,chk)
                        local ae=e:GetLabelObject()
                        local tc=e:GetHandler()
                        if tc:GetType()==TYPE_SPELL and tc:IsHasEffect(EFFECT_REMAIN_FIELD)==nil then
                            tc:CancelToGrave(false)
                        end
                        Effect.GetType = _ori_gettype
                        Effect.IsHasType = _ori_hastype
                        Duel.GetChainInfo = _ori_getchaininfo
                        e:Reset()
    end
end
function s.rmfilter(c,check)
	if check==0 and c:IsLocation(LOCATION_DECK) then return false end
	return c:IsSetCard(0x5A76) and c:IsAbleToRemove()
end
function s.nbfilter(c)
	return c:IsFaceup() and aux.NegateAnyFilter(c) and c:IsAbleToRemove()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
	e:SetLabel(1)
	if chkc then return chkc:IsOnField() and s.nbfilter(chkc) and c~=chkc end
	if chk==0 then return Duel.IsExistingTarget(s.nbfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) 
	and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e:GetLabel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.nbfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function s.rseop(e,tp,eg,ep,ev,re,r,rp)
    local ag=Duel.GetMatchingGroup(s.filter1, tp, LOCATION_HAND, 0, nil, e,tp,eg,ep,ev,re,r,rp)
    if ag:GetCount()>0 and s.check_act_Hand[tp+1] and Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id, 2))
        local ac=ag:Select(tp, 1, 1, nil):GetFirst()
        local ae={ac:GetActivateEffect()}
        ae=ae[1]
        local cost=ae:GetCost()
        local tg=ae:GetTarget()
        local op=ae:GetOperation()
        local pro1,pro2=ae:GetProperty()
        if cost==nil then cost=aux.TRUE end
        if tg==nil then tg=aux.TRUE end
        local ge=ae:Clone()
        ge:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
        ge:SetCode(EVENT_CUSTOM+id)
        ge:SetProperty(EFFECT_FLAG_DELAY|pro1,pro2)
        ge:SetRange(LOCATION_HAND)
        ge:SetCondition(function(...) return Duel.GetCurrentChain()==0 end )
        ge:SetCost(s.resolvecost(cost))
        ge:SetLabelObject(ae)
        ge:SetTarget(tg)
        if ac:GetOriginalCode()==12862920 then
            ge:SetTarget(s.tg)
        end
        ge:SetOperation(s.resolveoperation(op))
        ac:RegisterEffect(ge,true)
        Duel.RaiseSingleEvent(ac,EVENT_CUSTOM+id,re,r,rp,ep,ev)
    end
    if Duel.GetCurrentChain()>0 then
        e:Reset()
    end
    s.check_act_Hand[tp+1]=false
end
