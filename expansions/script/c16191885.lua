--繁开的心之辉光 洋牡丹
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,16191870)
	--超量召唤	
	aux.AddXyzProcedureLevelFree(c,s.mfilter,s.xyzcheck,2,99)
	c:EnableReviveLimit()
	--特召条件    
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(s.spcost)
	c:RegisterEffect(e0)
	--破坏    
	--适用效果    
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
    e1:SetCost(s.efcost)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
	--全抗   
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--额外攻击    
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
    if not s.global_flag then
		s.global_flag=true
		s[0]={}
		s[1]={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)	
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if not re or not re:GetHandlerPlayer() or not re:IsActiveType(TYPE_MONSTER) then return end
	for tc in aux.Next(eg) do
    	if not tc:IsSetCard(0x57b0) then return end
		local code=tc:GetCode()
		local tup=re:GetHandlerPlayer()
		if Duel.GetFlagEffect(tup,id)>0 then return end
		e:SetLabel(0)
		for _,fcode in ipairs(s[tup]) do
			if fcode==code then
				e:SetLabel(100)
			end
		end
		if e:GetLabel()==0 then table.insert(s[tup],code) end
		if #s[tup]>=8 then 
			Duel.RegisterFlagEffect(tup,id,0,0,0)			
		end
	end
end
function s.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and c:IsRank(5)
end
function s.xyzcheck(g)
	return g:IsExists(Card.IsCode,1,nil,16191870)
end
function s.spcost(e,c,tp,st)
	if st&SUMMON_TYPE_XYZ~=SUMMON_TYPE_XYZ then return true end
	return Duel.GetFlagEffect(tp,id)>0
end
function s.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return og:GetCount()>0 end
	Duel.SendtoGrave(og,REASON_EFFECT)
end
function s.tdfilter(c)
	return c:IsSetCard(0x57b0) and c:IsType(TYPE_MONSTER)
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()<=0 then return end
    local code=0
    local sg=Group.CreateGroup()
    for tc in aux.Next(g) do
    	local code=tc:GetCode()
        if not sg:IsExists(Card.IsCode,1,nil,code) then
        	sg:AddCard(tc)
        end
    end
    if sg:GetCount()<=0 then return end
    Duel.ShuffleDeck(tp)
    for sc in aux.Next(sg) do
		Duel.MoveSequence(sc,SEQ_DECKTOP)
	end	
    Duel.ConfirmDecktop(tp,sg:GetCount())
    Duel.SortDecktop(tp,tp,sg:GetCount())
    Duel.BreakEffect()
    local c=e:GetHandler()
	--不入连锁抽卡        
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
    e1:SetCountLimit(8)
	e1:SetCondition(s.drcon)
	e1:SetOperation(s.drop)
    e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--多id标记        
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(id)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp) 
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsPlayerCanDraw(tp,1)
end		
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
    	Duel.Hint(HINT_CARD,0,id)
    	Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function s.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end