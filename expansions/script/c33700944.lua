--动物朋友 丛林鸦
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33700944
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x5)
	local e1=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,cm.sprcon)	
	local e2=rsef.I(c,{m,0},1,"rm,ct","tg",LOCATION_MZONE,nil,nil,cm.tg,cm.op)
	--leave
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(cm.leaveop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetOperation(cm.leaveop2)
	c:RegisterEffect(e5)	
	e5:SetLabelObject(e4)
end
function cm.leaveop(e)
	local c=e:GetHandler()
	e:SetLabel(c:GetCounter(0x5))
end
function cm.leaveop2(e,tp)
	local ct=e:GetLabelObject():GetLabel()
	if ct>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Damage(1-tp,ct*800,REASON_EFFECT)
	end
end
function cm.sprcon(e,c)
	if not c then return true end
	local tp=c:GetControler()
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	local g1=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	return (#g1==0 or g1:GetClassCount(Card.GetCode)==#g1) and #g2>1 and g2:GetClassCount(Card.GetCode)==#g2
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	local f=function(c,p)
		return Duel.IsExistingMatchingCard(Card.IsCode,p,0,LOCATION_GRAVE,1,c,c:GetCode())
	end
	if chkc then return f(chkc,tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(f,tp,0,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,f,tp,0,LOCATION_GRAVE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,1-tp,0)
end
function cm.op(e,tp)
	local tc=rscf.GetTargetCard()
	if not tc then return end
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	local g2=Duel.GetDecktopGroup(1-tp,5)
	if #g2>0 then
		Duel.ConfirmDecktop(1-tp,5)
		g1:Merge(g2)
	end
	local rg=g1:Filter(Card.IsCode,nil,tc:GetCode())
	local ct=Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	local c=rscf.GetRelationCard()
	if c and ct>0 then
		c:AddCounter(0x5,ct)
	end
end
