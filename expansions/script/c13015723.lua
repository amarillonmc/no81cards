--深海姬·漂浮泡泡
function c13015723.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xe01),2,3) 
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe01)) 
	e1:SetValue(c13015723.matval)
	c:RegisterEffect(e1)
	--pos
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_POSITION) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,13015723)
	e1:SetTarget(c13015723.postg) 
	e1:SetOperation(c13015723.posop) 
	c:RegisterEffect(e1) 
	--pos link 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_CHANGE_POS) 
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,23015723)
	e2:SetCondition(c13015723.pscon) 
	e2:SetTarget(c13015723.pstg) 
	e2:SetOperation(c13015723.psop) 
	c:RegisterEffect(e2) 
end
function c13015723.exmatcheck(c,lc,tp)
	if not c:IsLocation(LOCATION_HAND) then return false end 
	return true
end
function c13015723.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(c13015723.exmatcheck,1,nil,lc,tp)
end 
function c13015723.postg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,LOCATION_MZONE)
end 
function c13015723.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		if tc:IsType(TYPE_MONSTER) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) 
		else  
		Duel.ChangePosition(tc,POS_FACEDOWN)   
				tc:CancelToGrave()  
				Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) 
	end
	if not tc:IsFacedown() then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			local lg=Group.FromCards(tc):Select(1-tp,1,1,nil)
			Duel.HintSelection(lg)
			Duel.Remove(lg,POS_FACEDOWN,REASON_RULE)
	end 
end 
end
function c13015723.pscon(e,tp,eg,ep,ev,re,r,rp)
	return re and not re:GetHandler():IsCode(13015723)   
end 
function c13015723.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCanChangePosition() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
	local b2=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) 
	if chk==0 then return (b1 or b2) end  
end 
function c13015723.psop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local b1=Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCanChangePosition() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
	local b2=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) 
	local op=2 
	if b1 and b2 then 
		op=Duel.SelectOption(tp,aux.Stringid(13015723,1),aux.Stringid(13015723,2))  
	elseif b1 then 
		op=Duel.SelectOption(tp,aux.Stringid(13015723,1))  
	elseif b2 then 
		op=Duel.SelectOption(tp,aux.Stringid(13015723,2))+1   
	end 
	if op==0 then  
		local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsFaceup() and c:IsCanChangePosition() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil) 
		Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)   
	elseif op==1 then  
		local sg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil) 
		Duel.ChangePosition(sg,POS_FACEDOWN)   
		local tc=sg:GetFirst() 
		while tc do 
		tc:CancelToGrave()  
		tc=sg:GetNext() 
		end 
		Duel.RaiseEvent(sg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) 
	end  
	local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil,c)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(13015723,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end 
end
