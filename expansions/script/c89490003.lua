--炯眼之吽
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=aux.AddRitualProcGreater2Code(c,89490004,LOCATION_HAND,nil,nil,true,s.extraop)
	e1:SetCategory(e1:GetCategory()|CATEGORY_DRAW)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsSetCard(0xc30) and c:IsReason(REASON_RELEASE)
end
function s.extraop(e,tp,eg,ep,ev,re,r,rp,tc,mat)
	if mat:IsExists(s.filter,1,nil) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0xc30) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
