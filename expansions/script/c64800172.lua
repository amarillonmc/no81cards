--黑暗界里设菲
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end

function s.df1(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function s.df2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function s.df3(c,ck1,ck2)
	return ((c:IsType(TYPE_MONSTER) and ck1) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and ck2)) and c:IsDiscardable() 
end
function s.mf(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ck1=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_SZONE,1,nil)
	local ck2=Duel.IsExistingMatchingCard(s.mf,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return (ck1 and Duel.IsExistingMatchingCard(s.df1,tp,LOCATION_HAND,0,1,e:GetHandler())) or (ck2 and Duel.IsExistingMatchingCard(s.df2,tp,LOCATION_HAND,0,1,e:GetHandler())) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=Duel.SelectMatchingCard(tp,s.df3,tp,LOCATION_HAND,0,1,1,nil,ck1,ck2):GetFirst()
	Duel.SendtoGrave(tc,REASON_DISCARD+REASON_COST)
	if tc:IsType(TYPE_MONSTER) then
		e:SetLabel(0)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,0,LOCATION_SZONE)
	end
	if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
		e:SetLabel(1) 
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_SZONE,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_SZONE,1,1,nil)
		if g:GetCount()>0 then
			local tgc=g:GetFirst()
			Duel.HintSelection(g)
			if Duel.SendtoGrave(tgc,REASON_EFFECT) and tgc:IsType(TYPE_CONTINUOUS) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and not tgc:IsForbidden() and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.MoveToField(tgc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
		end
	end
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(s.mf,tp,0,LOCATION_MZONE,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local tc=Duel.SelectMatchingCard(tp,s.mf,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		if Duel.GetControl(tc,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end