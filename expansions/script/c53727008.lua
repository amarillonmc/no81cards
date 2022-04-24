local m=53727008
local cm=_G["c"..m]
cm.name="记忆扩充精灵"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	if not cm.check then
		cm.check=true
		mg=Duel.GetFusionMaterial
		Duel.GetFusionMaterial=function(p)
			local g=Duel.GetMatchingGroup(function(c)return c:GetFlagEffect(m)>0 end,p,0,LOCATION_MZONE,nil)
			return Group.__add(mg(p),g)
		end
	end
end
function cm.thfilter(c)
	return c:IsCode(53727001) and c:IsAbleToHand()
end
function cm.slfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,m)==0
	local b2=Duel.IsExistingMatchingCard(cm.slfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetFlagEffect(tp,m+33)==0
	if chk==0 then return b1 or b2 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,m)==0
	local b2=Duel.IsExistingMatchingCard(cm.slfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetFlagEffect(tp,m+33)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2)) elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,1)) elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(m,2))+1 else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SELF)
		local tc=Duel.SelectMatchingCard(1-tp,cm.slfilter,1-tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,m+33,RESET_PHASE+PHASE_END,0,1)
	end
end
