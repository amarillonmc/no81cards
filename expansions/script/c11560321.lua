--和平维系者·宾森特
function c11560321.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,function(c) return c.SetCard_XdMcy end,aux.NonTuner(function(c) return c.SetCard_XdMcy end),2)
	c:EnableReviveLimit() 
	--xx
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)   
	e1:SetRange(LOCATION_EXTRA)  
	e1:SetCountLimit(1,11560321+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c11560321.xxcon) 
	e1:SetOperation(c11560321.xxop) 
	c:RegisterEffect(e1) 
	--dis  
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21560321)
	e2:SetTarget(c11560321.negtg)
	e2:SetOperation(c11560321.negop)
	c:RegisterEffect(e2)
end
c11560321.SetCard_XdMcy=true   
function c11560321.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic()	
end 
function c11560321.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.ConfirmCards(1-tp,c) 
	Duel.Hint(HINT_CARD,0,11560321) 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11560321,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_REMOVED) 
	e1:SetCost(c11560321.chcost)
	e1:SetTarget(c11560321.chtg)
	e1:SetOperation(c11560321.chop) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT) 
	e2:SetTargetRange(LOCATION_REMOVED,0)
	e2:SetTarget(function(e,c) 
	return c:IsType(TYPE_MONSTER) and c.SetCard_XdMcy end)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
end  
function c11560321.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(function(c) return c:IsAbleToDeckAsCost() and c:IsType(TYPE_MONSTER) end,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToDeckAsCost() and c:IsType(TYPE_MONSTER) end,tp,LOCATION_REMOVED,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler()) 
	Duel.SendtoDeck(g,nil,2,REASON_COST) 
end
function c11560321.chtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g1=Duel.GetDecktopGroup(tp,3)
	local g2=Duel.GetDecktopGroup(1-tp,3)
	if chk==0 then return g1:FilterCount(Card.IsAbleToRemove,nil)==3 and g2:FilterCount(Card.IsAbleToRemove,nil)==3 and Duel.GetFlagEffect(tp,11560321)==0 end 
	Duel.RegisterFlagEffect(tp,11560321,RESET_CHAIN,0,1) 
end
function c11560321.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c11560321.repop)
end
function c11560321.repop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetDecktopGroup(tp,3)
	local g2=Duel.GetDecktopGroup(1-tp,3) 
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
end 
function c11560321.negtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetMatchingGroup(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c11560321.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst() 
	while tc do  
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end 
	tc=g:GetNext() 
	end 
end


