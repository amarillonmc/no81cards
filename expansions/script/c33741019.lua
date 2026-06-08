--DEchoesD - Healing
local s,id,o=GetID()
Duel.LoadScript("c33741000.lua")
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(s.reccon)
	e1:SetTarget(s.rectg)
	e1:SetOperation(s.recop)
	c:RegisterEffect(e1)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and (r&REASON_BATTLE~=0 or r&REASON_EFFECT~=0 and rp==1-tp)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local maxc=math.min(math.ceil(ev/1000),Duel.GetMatchingGroupCount(DEchoes.ExtraKernel,tp,LOCATION_EXTRA,0,nil))
	if chk==0 then return maxc>0 end
	e:SetLabel(maxc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local maxc=e:GetLabel()
	local g=DEchoes.DestroyExtraKernel(tp,1,maxc)
	if g and Duel.Destroy(g,REASON_EFFECT)>0 then
		Duel.Recover(tp,#g*1000,REASON_EFFECT)
	end
end
