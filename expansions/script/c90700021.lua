local m=90700021
local cm=_G["c"..m]
cm.name="魔轰神兽 卡尔卡丹"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_CHANGE_LEVEL)
	e0:SetCondition(cm.lvcon)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetCondition(cm.sycon)
	e1:SetOperation(cm.syop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x35),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local egain=Effect.CreateEffect(c)
	egain:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	egain:SetCode(EVENT_ADJUST)
	egain:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	egain:SetRange(LOCATION_EXTRA)
	egain:SetOperation(cm.egainop)
	egain:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(egain)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(90700021)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(1,0)
	c:RegisterEffect(e0)
	if c90700021.counter==nil then
		c90700021.counter=true
		c90700021[0]=0
		c90700021[1]=0
		local edraw=Effect.CreateEffect(c)
		edraw:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		edraw:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		edraw:SetCode(EVENT_CHAIN_SOLVING)
		edraw:SetOperation(cm.edrawop)
		local edraw0=Effect.Clone(edraw)
		edraw0:SetLabel(0)
		Duel.RegisterEffect(edraw0,0)
		local edraw1=Effect.Clone(edraw)
		edraw1:SetLabel(1)
		Duel.RegisterEffect(edraw1,1)
		local ere=Effect.CreateEffect(c)
		ere:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ere:SetCode(EVENT_CHAIN_SOLVED)
		ere:SetOperation(cm.ereop)
		local ere0=Effect.Clone(ere)
		ere0:SetLabel(0)
		Duel.RegisterEffect(ere0,0)
		local ere1=Effect.Clone(ere)
		ere1:SetLabel(1)
		Duel.RegisterEffect(ere1,1)
	end
end
function cm.lvcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.stfilter1(c,tc)
	return (c:IsSetCard(0x35) or c:IsSetCard(0x11e)) and c:IsPosition(POS_FACEUP) and c:IsCanBeSynchroMaterial(tc)
end
function cm.stfilter2(c,tc)
	return ((not c:IsSetCard(0x35) and not c:IsSetCard(0x11e)) and c:IsSynchroType(TYPE_TUNER) and c:IsPosition(POS_FACEUP) and c:IsCanBeSynchroMaterial(tc)) or (not c:IsLevelAbove(0))
end
function cm.stfilterg(g,tp,tc,lv,smat)
	if smat then
		g:AddCard(smat)
	end
	return g:IsExists(cm.stfilter1,1,nil,tc) and (not g:IsExists(cm.stfilter2,1,nil,tc)) and g:GetSum(Card.GetLevel)>=4 and g:GetSum(Card.GetLevel)<=12 and Duel.GetLocationCountFromEx(tp,tp,g,tc)>0
end
function cm.sycon(e,c,smat,mg)
	if c==nil then return true end
	local lv=e:GetLabel()
	local tp=c:GetControler()
	if not mg then
		mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	end
	if smat then
		mg:RemoveCard(smat)
		return mg:CheckSubGroup(cm.stfilterg,1,nil,tp,c,lv,smat)
	else
		return mg:CheckSubGroup(cm.stfilterg,2,nil,tp,c,lv,nil)
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
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,1,nil,tp,c,lv,smat))
		g:AddCard(smat)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,2,nil,tp,c,lv,nil))
	end
	c:SetMaterial(g)
	e:GetLabelObject():SetValue(g:GetSum(Card.GetLevel))
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function cm.egainop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0x1ff,0x1ff,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(m)==0 then
			tc:RegisterFlagEffect(m,0,EFFECT_FLAG_IGNORE_IMMUNE,1)
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetRange(LOCATION_HAND)
			e1:SetCondition(cm.egdrcon)
			e1:SetDescription(aux.Stringid(90700021,0))
			e1:SetCost(cm.egdrcost)
			e1:SetOperation(cm.egdrop)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(tc)
			e2:SetDescription(aux.Stringid(90700021,3))
			e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
			e2:SetProperty(EFFECT_FLAG_DELAY)
			e2:SetCode(EVENT_SPSUMMON_SUCCESS)
			e2:SetCondition(cm.egthcon)
			e2:SetTarget(cm.egthtg)
			e2:SetOperation(cm.egthop)
			tc:RegisterEffect(e2,true)
			local e3=Effect.Clone(e2)
			e3:SetDescription(aux.Stringid(90700021,4))
			e3:SetCategory(CATEGORY_TOHAND)
			e3:SetCondition(cm.egrecon)
			e3:SetTarget(cm.egretg)
			e3:SetOperation(cm.egreop)
			tc:RegisterEffect(e3,true)
		end
		tc=g:GetNext()
	end
end
function cm.egdrcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsPlayerAffectedByEffect(tp,90700021)
end
function cm.egdrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable(REASON_COST) end
	e:SetLabel(e:GetHandler():GetControler())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.egdrop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsType(TYPE_MONSTER) and (tc:IsSetCard(0x35) or tc:IsSetCard(0x11e)) then
		local p=e:GetLabel()
		c90700021[p]=c90700021[p]+1
	end
end
function cm.egthcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0x35) and e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and Duel.IsPlayerAffectedByEffect(tp,90700021)
end
function cm.egthfilter(c)
	return (c:IsSetCard(0x35) or c:IsSetCard(0x11e)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.egthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.egthfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.egthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.egthfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.egrecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,90700021) and e:GetHandler():IsSetCard(0x11e)
end
function cm.egrefilter(c)
	return (c:IsSetCard(0x35) or c:IsSetCard(0x11e)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.egretg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.egrefilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.egreop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.egrefilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.edrawop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetLabel()
	if Duel.GetFlagEffect(tp,m)>0 then return end
	Duel.RegisterFlagEffect(tp,m,RESET_EVENT+RESET_CHAIN,0,1)
	if ep==tp or not Duel.IsPlayerCanDraw(tp) or c90700021[tp]==0 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(90700021,1)) then return end
	local dmax=c90700021[tp]
	local decknum=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if decknum<dmax then
		dmax=decknum
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(90700021,2))
	local opt={}
	for i=1,dmax do
		opt[i]=i
	end
	opt[dmax+1]=nil
	local drawnum=Duel.AnnounceNumber(tp,table.unpack(opt))
	Duel.Draw(tp,drawnum,REASON_EFFECT)
	c90700021[tp]=c90700021[tp]-drawnum
end
function cm.ereop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(e:GetLabel(),m)
end