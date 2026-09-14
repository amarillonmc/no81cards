--禁牙的变貌 诺玛格达拉
local s,id,o=GetID()
function s.initial_effect(c)
	--融合召唤
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),aux.FilterBoolFunction(Card.IsLocation,LOCATION_DECK),true)
    c:EnableReviveLimit()
	--特召条件    
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(s.spcost)
	c:RegisterEffect(e0)
	--适用效果    
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.efcon)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
	--破坏耐性    
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--抽卡    
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCountLimit(1,id+o)
	e3:SetCondition(s.drcon)
	e3:SetTarget(s.drtg)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)
    if not s.global_flag then
		s.global_flag=true
		s[0]={}
		s[1]={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)	
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)	
	for tc in aux.Next(eg) do
    	if tc:IsType(TYPE_FUSION) then
			local code=tc:GetCode()
			if Duel.GetFlagEffect(tc:GetSummonPlayer(),id)>0 then return end
			e:SetLabel(0)
			for _,fcode in ipairs(s[tc:GetSummonPlayer()]) do
				if fcode==code then
					e:SetLabel(100)
				end
			end
			if e:GetLabel()==0 then table.insert(s[tc:GetSummonPlayer()],code) end
			if #s[tc:GetSummonPlayer()]>=3 then 
				Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id,0,0,0)
            end
		end
	end
end
function s.spcost(e,c,tp,st)
	if st&SUMMON_TYPE_FUSION~=SUMMON_TYPE_FUSION then return true end
	return Duel.GetTurnCount()>=3
end
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.atkfilter(c)
	return c:IsFaceup() and (c:GetAttack()>0 or c:GetDefense()>0)
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.atkfilter,tp,0,LOCATION_MZONE,1,nil)
    local b2=Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return (b1 or b2) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1800)
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=1
    if Duel.GetFlagEffect(tp,id)>0 then ct=2 end
	for i=1,ct do
    	if i>1 then 
        	if Duel.SelectYesNo(tp,aux.Stringid(id,4)) then Duel.BreakEffect()
        	else break end
        end
		local b1=Duel.IsExistingMatchingCard(s.atkfilter,tp,0,LOCATION_MZONE,1,nil)
    	local b2=Duel.IsPlayerCanDraw(tp,1)
    	if not b1 and not b2 then break end
    	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,2),1},
			{b2,aux.Stringid(id,3),2})
    	if op==1 then
    		local g=Duel.GetMatchingGroup(s.atkfilter,tp,0,LOCATION_MZONE,nil)
            local dg=Group.CreateGroup()
            for tc in aux.Next(g) do
				local patk=tc:GetAttack()
                local pdef=tc:GetDefense()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-2400)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
                local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				tc:RegisterEffect(e2)
				if (patk~=0 and tc:IsAttack(0)) or (pdef~=0 and tc:IsDefense(0)) then 
                	dg:AddCard(tc) 
                end
			end
			if dg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Destroy(dg,REASON_EFFECT)    
    		end
    	elseif op==2 then
        	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
            	Duel.Recover(tp,1800,REASON_EFFECT)
            end
    	end
    end
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,600)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
    	Duel.Recover(tp,600,REASON_EFFECT)
   	end
end