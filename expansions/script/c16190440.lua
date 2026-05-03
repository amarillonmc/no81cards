--双月的丽妖狐
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	c:EnableReviveLimit()
	--特召条件
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--特召规则
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.sprcon)
	e1:SetTarget(s.sprtg)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)
	--特召代价    
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_COST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCost(s.spcost)
	e2:SetOperation(s.spcop)
	c:RegisterEffect(e2)
	--适用效果    
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(s.bhtg)
	e3:SetOperation(s.bhop)
	c:RegisterEffect(e3)
	--素材限制    
    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(s.fuslimit)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e7)
	--攻守上升    
    local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(s.adval)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e9)
	--攻击两次    
    local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_EXTRA_ATTACK)
	e10:SetValue(1)
	c:RegisterEffect(e10)
    Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
function s.chainfilter(re,tp)
	return not re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end    
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
    local dt=Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)
    local ct=2-dt
    if ct>=1 then
		local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON)        
		return g:CheckSubGroup(aux.mzctcheckrel,ct,ct,tp,REASON_SPSUMMON)
	else
    	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    end      
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local dt=Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)
    local ct=2-dt
    if ct>=1 then
		local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=g:SelectSubGroup(tp,aux.mzctcheckrel,true,ct,ct,tp,REASON_SPSUMMON)
		if sg then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			return true
		else return false end   
	else
    	return true
    end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local dt=Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)
    local ct=2-dt
    if ct>=1 then 
		local sg=e:GetLabelObject()
		Duel.Release(sg,REASON_SPSUMMON)
		sg:DeleteGroup()	
	end               
end
function s.spcost(e,c,tp)
	return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0
end
function s.spcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
end
function s.bhmfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function s.bhsfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.bhtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.bhmfilter,tp,0,LOCATION_MZONE,1,nil) 
    local b2=Duel.IsExistingMatchingCard(s.bhsfilter,tp,0,LOCATION_ONFIELD,1,nil) 
	if chk==0 then return (b1 or b2) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD)
    Duel.SetChainLimit(s.climit)
end
function s.climit(re,rp,tp)
	return not re:GetHandler():IsType(TYPE_MONSTER)
end
function s.bhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	for i=1,2 do
		local b1=Duel.IsExistingMatchingCard(s.bhmfilter,tp,0,LOCATION_MZONE,1,nil) 
    	local b2=Duel.IsExistingMatchingCard(s.bhsfilter,tp,0,LOCATION_ONFIELD,1,nil) 
		local b3=i>1
        if not b1 and not b2 then break end
        local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2},
			{b3,aux.Stringid(id,3),3})
		if i>1 and op~=3 then
			Duel.BreakEffect()
		end
        if op==1 then
        	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,s.bhmfilter,tp,0,LOCATION_MZONE,1,1,nil)
			if g:GetCount()>0 then
            	Duel.HintSelection(g)
            	Duel.SendtoHand(g,nil,REASON_RULE,1-tp)
        	end
        elseif op==2 then
        	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,s.bhsfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
        		Duel.HintSelection(g)
                Duel.SendtoHand(g,nil,REASON_RULE,1-tp)
            end   
        elseif op==3 then
        	break
        end
	end
end
function s.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function s.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,LOCATION_HAND)*100
end