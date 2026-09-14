--混沌军势
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetOperation(s.checkop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.checkop1(e,tp,eg,ep,ev,re,r,rp)
	if re and re:IsHasCategory(CATEGORY_FUSION_SUMMON) then
		Duel.RegisterFlagEffect(re:GetHandlerPlayer(),id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	if re and re:IsHasCategory(CATEGORY_FUSION_SUMMON) then
		local ct=Duel.GetFlagEffect(re:GetHandlerPlayer(),id) or 0
		Duel.ResetFlagEffect(re:GetHandlerPlayer(),id)
		if ct>1 then
			for i=1,ct-1 do
				Duel.RegisterFlagEffect(re:GetHandlerPlayer(),id,RESET_PHASE+PHASE_END,0,1)
			end
		end
	end
end
function s.confilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function s.tdfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsAbleToExtra()
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFlagEffect(tp,id)
    if ct>3 then ct=3 end
	local b1=ct>0 and Duel.IsPlayerCanDraw(tp,ct)
    local b2=Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_MZONE,0,1,nil)
    	and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
    local b3=Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return (b1 or b2 or b3) end
    local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1},
		{b2,aux.Stringid(id,2),2},
        {b3,aux.Stringid(id,3),3})
	e:SetLabel(op)
    if op==1 then
    	e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
        e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(ct)
        Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)        
    elseif op==2 then
    	e:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
        e:SetProperty(0)
        local dg=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,dg,1,0,0)
    elseif op==3 then
    	e:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
        Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)   
        Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1600)
    end	 
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
    if op==1 then
    	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local ct=Duel.GetFlagEffect(tp,id)
        if ct<=0 then return end
    	if ct>3 then ct=3 end
        local dt=Duel.Draw(p,ct,REASON_EFFECT)
		if dt>=2 then
			local rt=dt-1
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,rt,rt,nil)
			Duel.ShuffleHand(p)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
    elseif op==2 then
    	local st=Duel.GetMatchingGroupCount(s.confilter,tp,LOCATION_MZONE,0,nil)
        if st<=0 then return end
    	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local tg=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,st,c)
    	if tg:GetCount()<=0 then return end
        Duel.HintSelection(tg)
        for tc in aux.Next(tg) do
			if tc:IsCanBeDisabledByEffect(e,false) then			
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e3)
                end
                Duel.AdjustInstantly()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end	
    elseif op==3 then
    	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local fc=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
        if not fc then return end
        Duel.HintSelection(Group.FromCards(fc))
        if Duel.SendtoDeck(fc,nil,2,REASON_EFFECT)~=0 and fc:IsLocation(LOCATION_EXTRA) then
        	Duel.Damage(1-tp,1600,REASON_EFFECT)
        end
    end    
end