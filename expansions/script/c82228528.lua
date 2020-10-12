function c82228528.initial_effect(c)  
	--link summon  
	aux.AddLinkProcedure(c,nil,2,2,c82228528.lcheck)  
	c:EnableReviveLimit()
	--search  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228528,0))  
	e1:SetCategory(CATEGORY_DRAW)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,82228528)  
	e1:SetCondition(c82228528.drcon)
	e1:SetTarget(c82228528.drtg)  
	e1:SetOperation(c82228528.drop)  
	c:RegisterEffect(e1) 
	--summon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228528,1))  
	e2:SetCategory(CATEGORY_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,82218528)
	e2:SetCost(c82228528.sumcost)  
	e2:SetTarget(c82228528.sumtg)  
	e2:SetOperation(c82228528.sumop)  
	c:RegisterEffect(e2)  
	if not c82228528.global_check then  
		c82228528.global_check=true  
		local ge1=Effect.CreateEffect(c)  
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)  
		ge1:SetLabel(82228528) 
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		ge1:SetOperation(aux.sumreg)  
		Duel.RegisterEffect(ge1,0)   
	end  
end   
 
function c82228528.lcheck(g,lc)  
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_WATER)  
end  
function c82228528.drcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetFlagEffect(82228528)>0  
end  
function c82228528.tgfilter(c)  
	return c:GetMutualLinkedGroupCount()>0 
end  
function c82228528.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82228528.tgfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp) end  
	local ct=Duel.GetMatchingGroupCount(c82228528.tgfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(ct)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)  
end  
function c82228528.drop(e,tp,eg,ep,ev,re,r,rp) 
	local ct=Duel.GetMatchingGroupCount(c82228528.tgfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)  
	Duel.Draw(p,ct,REASON_EFFECT)  
end  
function c82228528.sumfilter(c)  
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSummonable(true,nil)  
end  
function c82228528.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLPCost(tp,500) end  
	Duel.PayLPCost(tp,500)  
end  
function c82228528.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228528.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)  
end  
function c82228528.sumop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)  
	local g=Duel.SelectMatchingCard(tp,c82228528.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)  
	local tc=g:GetFirst()  
	if tc then  
		Duel.Summon(tp,tc,true,nil)  
	end   
end  