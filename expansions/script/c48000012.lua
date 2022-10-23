--灭剑炎龙
local m=48000012
local cm=_G["c"..m]

function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.flagcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetValue(SUMMON_TYPE_SYNCHRO)
	e3:SetCondition(cm.sycon)
	e3:SetOperation(cm.syop)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,48000012)
	e1:SetCondition(cm.descon)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
end

function cm.stfilter1(c,tc,g)
	local tg=g:Clone()
	tg:RemoveCard(c)
	return c:IsPosition(POS_FACEUP) and c:IsCanBeSynchroMaterial(tc) and c:IsSynchroType(TYPE_TUNER) and c:IsRace(RACE_DRAGON) and tg:FilterCount(cm.stfilter2,nil,tc)==tg:GetCount()
end
function cm.stfilter2(c,tc)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSynchroMaterial(tc) and c:IsPosition(POS_FACEUP) 
end
function cm.stfilterg(g,tp,tc,smat)
	if smat then
		g:AddCard(smat)
	end
	return g:GetSum(Card.GetLevel)>=8  and Duel.GetLocationCountFromEx(tp,tp,g,tc)>0 and g:FilterCount(cm.stfilter1,nil,tc,g)>=1
end
function cm.sycon(e,c,smat,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	if not mg then
		mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	end
	if smat then
		mg:RemoveCard(smat)
		return mg:CheckSubGroup(cm.stfilterg,1,nil,tp,c,smat)
	else
		return mg:CheckSubGroup(cm.stfilterg,2,nil,tp,c,nil)
	end
end
function cm.syop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local lv=e:GetLabel()
	if not mg then
		mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	end
	local g=Group.CreateGroup()
	if smat then
		mg:RemoveCard(smat)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,1,nil,tp,c,smat))
		g:AddCard(smat)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,2,nil,tp,c,nil))
	end
	c:SetMaterial(g)
	local lvt=g:GetSum(Card.GetLevel)
	e:GetLabelObject():SetLabel(g:GetSum(Card.GetLevel)-7)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end

function cm.flagcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()>1
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   if e:GetLabel()>=4 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetAbsoluteRange(ep,0,1)
		c:RegisterEffect(e1,true)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
   end
   if e:GetLabel()>=1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
   end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.thfilter(c)
	return c:IsCode(48000000) and c:IsAbleToHand() 
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	if e:GetHandler():GetFlagEffect(m)~=0 then
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
		
end