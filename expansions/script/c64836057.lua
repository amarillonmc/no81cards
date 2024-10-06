--青釭剑
local s,id=GetID()
function s.initial_effect(c)
	  aux.AddCodeList(c,64836050)
	--cannot activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_TRIGGER)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCondition(s.con)
	c:RegisterEffect(e0)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
 --
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
--
function s.con(e)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,64836050)==0 and not c:IsLocation(LOCATION_SZONE)
end
--
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500)  end
	Duel.PayLPCost(tp,500)
end
function s.setfilter(c)
	return aux.IsCodeListed(c,64836050)  and c:IsType(TYPE_SPELL+TYPE_TRAP) and  c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4
	end
	Duel.SetTargetPlayer(tp)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5)
	if g:GetCount()>0 and g:IsExists(s.setfilter,1,nil) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SET)
		local tc=g:FilterSelect(tp,s.setfilter,1,1,nil):GetFirst()
		if tc then  
		   Duel.SSet(tp,tc)
		   Duel.ConfirmCards(1-tp,tc)
		end
	end
	Duel.ShuffleDeck(p)
end
--
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return   Duel.GetFlagEffect(tp,64836050)>0
end
function s.posfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function s.posfilter2(c)
	return c:IsPosition(POS_FACEUP_ATTACK) 
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(s.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(s.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.posfilter,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	end
	local g2=Duel.GetMatchingGroup(s.posfilter2,tp,0,LOCATION_MZONE,nil)
	if g2:GetCount()>0 then 
	Duel.SendtoDeck(g2,nil,2,REASON_EFFECT+REASON_RULE)
	end
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetValue(DOUBLE_DAMAGE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE)
		Duel.RegisterEffect(e1,tp)
end















