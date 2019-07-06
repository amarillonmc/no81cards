--平行世界超载
function c11113105.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11113105+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c11113105.cost)
	e1:SetTarget(c11113105.target)
	e1:SetOperation(c11113105.activate)
	c:RegisterEffect(e1)
	if not c11113105.global_check then
		c11113105.global_check=true
		c11113105[0]=0
		c11113105[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c11113105.check)
		Duel.RegisterEffect(ge1,0)
	end
end
function c11113105.check(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsCode(11113105) then
		c11113105[ep]=c11113105[ep]+1
		if c11113105[ep]>=2 then
			Duel.RegisterFlagEffect(ep,11113105,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end	
	end
end
function c11113105.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c11113105.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=5-Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,e:GetHandler())
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c11113105.rtfilter(c,tp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,c,c:GetCode())
end
function c11113105.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=5-Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if ct>0 and Duel.Draw(p,ct,REASON_EFFECT)~=0 then
	    local ph=Duel.GetCurrentPhase()
		if ph==PHASE_MAIN1 then
	        Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		    local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,p)
		elseif ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE then
		    Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		else
		    Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
        end		
        Duel.BreakEffect()
		local hg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
		Duel.ConfirmCards(1-p,hg)
		if hg:IsExists(c11113105.rtfilter,1,nil,p) 
		   and Duel.GetMatchingGroupCount(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)>0 then
			Duel.SendtoDeck(hg,nil,2,REASON_EFFECT)
		end
        Duel.ShuffleHand(p)		
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c11113105.dmcon)
	e2:SetOperation(c11113105.dmop)
	Duel.RegisterEffect(e2,p)
end	
function c11113105.dmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,11113105)~=0
end
function c11113105.dmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,11113105)
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if not tc:IsCode(11113105) then
	    Duel.SetLP(tp,0)
	end	
end