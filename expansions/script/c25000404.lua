--群魔
local m=25000404
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.check(c,e,tp)
	return c:IsType(TYPE_NORMAL) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummon(tp,SUMMON_TYPE_SPECIAL,POS_FACEUP,1-tp,c) and Duel.IsExistingMatchingCard(cm.check2,tp,LOCATION_HAND,0,1,c,e,tp)
end
function cm.check2(c,e,tp)
	return c:IsType(TYPE_EFFECT) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end 
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.check,tp,LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()==0 then return end
	local g2=Duel.GetMatchingGroup(cm.check2,tp,LOCATION_HAND,0,g,e,tp)
	local tc=g2:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC_G)
		e1:SetRange(LOCATION_HAND)
		e1:SetCondition(cm.mtcon())
		e1:SetOperation(cm.mtdo())   
		e1:SetReset(RESET_EVENT+0x7e0000)
		e1:SetValue(SUMMON_TYPE_SPECIAL)
		tc:RegisterEffect(e1)
	Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_SPECIAL)
end
function cm.mtcon()
	return function(e,c,og)
				if c==nil then return true end
				local tp=c:GetControler()
				local g=Duel.GetMatchingGroup(cm.check,tp,LOCATION_HAND,0,nil,e,tp)
				return g:GetCount()>0
			end
end
function cm.gselect(g,e,tp)
	return Duel.IsExistingMatchingCard(cm.spchk,tp,LOCATION_HAND,0,#g,g,e,tp)
end
function cm.spchk(c,e,tp)
	return c:IsType(TYPE_EFFECT) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.mtdo()
	return  function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
				if not sg then
					sg=Group.CreateGroup()
				end
				local g=Duel.GetMatchingGroup(cm.check,tp,LOCATION_HAND,0,nil,e,tp)
				local spg=Duel.GetMatchingGroup(cm.spchk,tp,LOCATION_HAND,0,nil,e,tp)
				local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ct2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
				local ft=math.min(ct,ct2)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=g:SelectSubGroup(tp,cm.gselect,false,1,ft,e,tp)
				if not g then
					return
				end
				for tc in aux.Next(g) do
					Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP)
				end
				Duel.SpecialSummonComplete()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local rg=spg:Select(tp,#g,#g,g)
				sg:Merge(rg)
				e:Reset()
				return sg
			end
end