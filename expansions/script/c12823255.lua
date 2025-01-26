--舞斗-连弹的协奏曲
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12823215)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.con)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==3 or Duel.GetCurrentChain()==7
end
function s.atkfilter(c)
	return c:IsSetCard(0xaa70) and c:IsFaceup() and c:GetAttackableTarget()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cl=Duel.GetCurrentChain()
	local ph=Duel.GetCurrentPhase()
	if ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=Duel.SelectMatchingCard(tp,s.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(sg)
	local tc1=sg:GetFirst()
	local g=c:GetAttackableTarget()
	if #g>0 and Duel.SelectOption(tp,1157,1117)==0 then
		local tc2=g:Select(tp,1,1,nil):GetFirst()
		if tc2 then
			Duel.CalculateDamage(tc1,tc2)
		end
	else Duel.CalculateDamage(tc1,nil,false)
	end
	for i=1,cl do
		local code,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_PLAYER)
		if tgp==tp and code==id then
		c:RegisterFlagEffect(id,RESET_CHAIN,1,0)
	end
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil,POS_FACEUP)
		if c:GetFlagEffect(id)==2 and #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) 
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,0,1,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_MUSIC,0,aux.Stringid(id,2))
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function s.filter(c)
	return c:IsFaceup() and c:IsCode(12823215)
end