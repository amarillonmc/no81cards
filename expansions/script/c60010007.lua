--简丝 传说天之剑岚
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	MTC.LHini(c)
	MTC.LHSpS(c,2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.thfil,tp,0,LOCATION_ONFIELD,1,1,c)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local ti=math.min(MTC.LHnum(tp),Duel.GetFieldGroupCount(tp,0,LOCATION_DECK))
		local rg=Duel.GetDecktopGroup(1-tp,ti)
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	end
end