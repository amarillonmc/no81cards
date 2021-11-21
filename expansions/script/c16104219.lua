--天命教枢 教化之核
if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
local m,cm=rk.set(16104219)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.link,2,2,nil)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.matcon)
	e1:SetOperation(cm.matop)
	c:RegisterEffect(e1)
	e0:SetLabelObject(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetCondition(cm.condition1)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCondition(cm.condition2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,4))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m+1)
	e4:SetCondition(cm.thcon)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
end
function cm.link(c)
	return c:IsLinkSetCard(0xccd)
end
function cm.valcheck(e,c)
	local mg=c:GetMaterial()
	if #mg>0 and mg:FilterCount(Card.IsSummonType,nil,SUMMON_TYPE_ADVANCE)==#mg then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHandAsCost,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHandAsCost,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoHand(g,tp,REASON_COST)
end
function cm.condition1(e,tp)
	return e:GetHandler():GetFlagEffect(m)==0
end
function cm.condition2(e,tp)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.actfilter(c,tp)
	return c:IsCode(16104206) and c:GetActivateEffect():IsActivatable(tp,true,true) 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,0)
end
function cm.rllfilter(c,tp)
	return c:IsReleasable() and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,nil,c)
end 
function cm.sumfilter(c,rc)
	local minc,maxc=c:GetTributeRequirement()
	local g=Duel.GetTributeGroup(rc)
	return g:CheckSubGroup(cm.checkfun,1,maxc,c,rc,minc,maxc) or c:IsLevelBelow(4)
end
function cm.checkfun(g,rc,c,minc,maxc)
	return Duel.CheckTribute(rc,minc,maxc,g) and not g:IsContains(c) and not g:IsContains(rc)
end
function cm.operation(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,cm.actfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local te=tc:GetActivateEffect()
		local ft=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if ft then
			Duel.SendtoGrave(ft,REASON_RULE)
			Duel.BreakEffect()
		end
		if Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_FZONE,POS_FACEUP,true) then
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
			if Duel.IsExistingMatchingCard(cm.rllfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
				Duel.ShuffleDeck(tp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local g=Duel.SelectMatchingCard(tp,cm.rllfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
				if g:GetCount()>0 then
					Duel.Release(g,REASON_EFFECT)
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
					local sg=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND,0,1,1,nil,true,nil)
					if sg:GetCount()>0 then
						local tc=sg:GetFirst()
						Duel.Summon(tp,tc,true,nil)
					end
				end
			end
		end
	end
end
function cm.resfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.thcon(e,tp,eg)
	return eg:IsExists(cm.resfilter,1,nil,tp)
end
function cm.addfilter(c,sc)
	return (c:IsSetCard(0x3ccd) or (sc:GetFlagEffect(m)>0 and c:IsAttack(2800) and c:IsDefense(2000))) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.addfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.addfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end