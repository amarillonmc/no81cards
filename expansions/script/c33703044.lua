--虚·虚拟YouTuber Neuro-sama
local m=33703044
local s=33703044
local id=33703044
local o=33703044
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x445),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x1010)
	--synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	e0:SetLabel(8)
	e0:SetCondition(cm.sycon)
	e0:SetOperation(cm.syop)
	c:RegisterEffect(e0)
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK) 
	e1:SetValue(cm.valcheck)
	c:RegisterEffect(e1)
	--synchro success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	e2:SetLabelObject(e1)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.addcon)
	e3:SetOperation(cm.addop)
	c:RegisterEffect(e3)
	local e33=e3:Clone()
	e33:SetCode(EVENT_DRAW)
	e33:SetCondition(cm.addcon1)
	c:RegisterEffect(e33)
	--draw count
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DRAW) 
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(0)
	e4:SetReset(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCondition(cm.dccon)
	e4:SetOperation(cm.dcop)
	c:RegisterEffect(e4)
	local e7=e4:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetLabel(0)
	e7:SetCondition(cm.spgcon)
	e7:SetOperation(cm.spgop)
	c:RegisterEffect(e7)
	--draw 1
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(cm.dcost)
	e5:SetCondition(cm.dcon)
	e5:SetTarget(cm.dtg)
	e5:SetOperation(cm.dop)
	c:RegisterEffect(e5)
	e5:SetLabelObject(e4)
	-- draw 2
	local e6=e5:Clone()
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCondition(cm.spgcon)
	e6:SetOperation(cm.dspop)
	c:RegisterEffect(e6)
	e6:SetLabelObject(e7)

	
end
function cm.spgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function cm.chkfilter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsSummonLocation(LOCATION_GRAVE)
end
function cm.spgop(e,tp,eg,ep,ev,re,r,rp)
	local temp =e:GetLabel()
	if eg:Filter(cm.chkfilter,nil,tp):GetCount()~=0 then
	e:SetLabel(temp+eg:GetCount())
	end
	if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_END then
	e:SetLabel(0)
	end
end
function cm.dspop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,e:GetLabelObject():GetLabel(),REASON_EFFECT)
end
function cm.dccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function cm.dcop(e,tp,eg,ep,ev,re,r,rp)
	local temp = e:GetLabel()
	e:SetLabel(temp+ev)
	if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_END then
	e:SetLabel(0)
	end
end
function cm.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x1010) ~=0 end

	e:GetHandler():RemoveCounter(tp,0x1010,1,REASON_COST)

end
function cm.dcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk ==0 then return (e:GetLabelObject():GetLabel()>0 or Duel.GetFlagEffect(1-tp,id+o)>0) and Duel.IsPlayerCanDraw(tp)  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_DRAW,g,1,0,0)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Draw(tp,e:GetLabelObject():GetLabel(),REASON_EFFECT)
end



function cm.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function cm.tfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function cm.addcon1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.tfilter,nil,tp)
	return (Duel.GetTurnPlayer~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW and g:GetCount()>0)
end
function cm.addcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.tfilter,nil,tp)
	return Duel.GetTurnPlayer~=tp  and eg:IsExists(cm.cfilter,1,nil,1-tp)
end
function cm.addop(e,tp,eg,ep,ev,re,r,rp)
	 Card.AddCounter(e:GetHandler(),0x1010,1)
end


function cm.stfilter1(c,tc)
	return c:IsSynchroType(TYPE_TUNER) and c:IsPosition(POS_FACEUP) and c:IsCanBeSynchroMaterial(tc)
end
function cm.stfilter2(c,tc)
	return c:IsPosition(POS_FACEUP) and c:IsCanBeSynchroMaterial(tc) and not c:IsSynchroType(TYPE_TUNER)
end
function cm.stfilterg(g,tp,tc,lv,smat)
	if smat then
		g:AddCard(smat)
	end
	local g1=g:Filter(cm.stfilter1,nil,tc)
	local g2=g:Filter(cm.stfilter2,nil,tc)
	local count=g:GetCount()
	return g1:GetCount()==1 and g2:GetCount()==count-1 and g:GetSum(Card.GetLevel)==lv and Duel.GetLocationCountFromEx(tp,tp,g,tc)>0
end
function cm.sycon(e,c,smat,mg)
	if c==nil then return true end
	if c:IsFaceup() then return false end
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
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	local mt=0
	local tc=g:GetFirst()
	while tc do
		if tc:IsSetCard(0x445) then
			mt =1
			e:SetLabel(mt)
		end
		tc=g:GetNext()
	end

end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
	and e:GetLabelObject():GetLabel()==0 
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
			if e:GetLabelObject():GetLabel()==0 then
			local c=e:GetHandler()
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_DISABLE_EFFECT)
			e4:SetValue(RESET_TURN_SET)
			--c:RegisterEffect(e4)
			--Duel.AdjustInstantly(c)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(c:GetBaseAttack()+1500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			e2:SetValue(c:GetBaseDefense()+1500)
			c:RegisterEffect(e2,true)
			end
end
