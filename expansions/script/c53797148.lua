if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	s.zero_seal_effect=e1
	SNNM.zero_seal_check(id,e1,3)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	if Duel.SendtoGrave(c,REASON_COST)>0 and c:IsLocation(LOCATION_GRAVE) then c:RegisterFlagEffect(53797644,RESET_EVENT+RESETS_STANDARD,0,1) end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)<=0 then
		Duel.RegisterFlagEffect(tp,id,0,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetLabelObject(re)
		e1:SetTarget(s.sumlimit)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		e:GetHandler():SetFlagEffectLabel(53797644,1)
	end
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se==e:GetLabelObject() and c:IsType(TYPE_MONSTER)
end
s.category=CATEGORY_REMOVE
function s.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function s.exop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
end
