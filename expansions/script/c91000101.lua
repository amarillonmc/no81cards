--人机增强
local cm,m=GetID()
function c91000101.initial_effect(c)
		local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_DRAW)
	e1:SetCost(aux.bfgcost)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) then  Duel.Draw(tp,1,REASON_EFFECT) end
--抽 卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local lv=Duel.AnnounceLevel(tp,2,6)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetTargetRange(0,1)
	e2:SetValue(lv)
	Duel.RegisterEffect(e2,tp)
	Duel.Draw(1-tp,lv-1,REASON_RULE)
--通 常 召 唤
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local ln=Duel.AnnounceLevel(tp,2,10)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetValue(ln)
	Duel.RegisterEffect(e3,tp)
--回 复
	if  Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_NUMBER)
	local lp=Duel.AnnounceLevel(tp,1,8)
	--local t={8,16,32,64}
	--local lp=(Duel.AnnounceNumber(tp,table.unpack(t)))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_DRAW)
	e1:SetRange(0xff)
	e1:SetCountLimit(1)
	e1:SetLabel(lp)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.activate2)
	Duel.RegisterEffect(e1,tp)
end
--追 加 次 数
	if Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
	--Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_NUMBER)
	--local gc=Duel.AnnounceLevel(tp,1,3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(0xff)
	e4:SetCondition(cm.addcon)
	e4:SetOperation(cm.addop)
	Duel.RegisterEffect(e4,tp)
	end
--改 变 手 卡
	--if Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
	--local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	--Duel.ConfirmCards(tp,g2)
   -- local g=g2:Select(tp,0,6,nil)
	--Duel.SendtoDeck(g,nil,3,REASON_EFFECT)
  --  local g1=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
   -- Duel.ConfirmCards(tp,g1)
	--local g=g1:Select(tp,0,g:GetCount(),nil)
   -- Duel.SendtoHand(g,nil,REASON_RULE)
	--end
--增 加 资 源
	if  Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local ld=Duel.AnnounceLevel(tp,5,15)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(0xff)
	e4:SetCountLimit(1)
	e4:SetLabel(ld)
	e4:SetCondition(cm.con)
	e4:SetOperation(cm.activate3)
	Duel.RegisterEffect(e4,tp)
	end
--增 加 战 斗 阶 段
	if  Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
	local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_BP_TWICE)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetTargetRange(0,1)
		Duel.RegisterEffect(e5,tp)
end
--战 斗 结 束 特 招
	if  Duel.SelectYesNo(tp,aux.Stringid(m,7)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sp=Duel.AnnounceLevel(tp,1,3)
	local e6=Effect.CreateEffect(e:GetHandler())
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e6:SetCountLimit(1)
	e6:SetLabel(sp)
	e6:SetCondition(cm.con)
	e6:SetOperation(cm.spop)
	Duel.RegisterEffect(e6,tp)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local lp=e:GetLabel()
	Duel.Recover(1-e:GetHandlerPlayer(),lp*1000,REASON_EFFECT) 
end
function cm.activate3(e,tp,eg,ep,ev,re,r,rp)
	local ld=e:GetLabel()
	local tp=e:GetHandlerPlayer()
		local g1=Duel.GetMatchingGroup(nil,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil) 
		if  #g1<0 then return end
		local n=math.min(#g1,ld)
		local g=g1:RandomSelect(tp,n)
		local tc=g:GetFirst()
		local g2=Group.CreateGroup()
		while tc do 
		local nc=Duel.CreateToken(1-tp,tc:GetCode())
		g2:AddCard(nc)
		tc=g:GetNext()
		end
		Duel.SendtoDeck(g2,nil,3,REASON_RULE)
end

function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local sp=e:GetLabel()
	local tp=e:GetHandlerPlayer()
	if Duel.GetTurnPlayer()~=e:GetHandlerPlayer() then
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil,e,tp)
	if g2:GetCount()>0 then
	local n=math.min(sp,#g2)
	local g=g2:RandomSelect(t,n)
		Duel.SpecialSummon(g,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
	end
end
function cm.change_effect(effect,count)
	local eff=effect:Clone()
	local etype=EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_FLIP+EFFECT_TYPE_IGNITION+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_QUICK_F
	local limcount,limid=effect:GetCountLimit() 
	limid=limid^EFFECT_COUNT_CODE_DUEL
	if effect:GetType()&etype~=0 and limid then
		eff:SetCountLimit(limcount+count,limid)
		--eff:SetReset(RESET_PHASE+PHASE_END)
		return eff
	else
		return 0
	end
end

function cm.addcon(e,tp,eg,ep,ev,re,r,rp)   
	local rc=re:GetHandler()	
	return not rc.Is_Add_Effect_Id
end
function cm.addop(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()
	local rc=re:GetHandler()
	local tc=_G["c"..rc:GetOriginalCode()]
	if not tc.Is_Add_Effect_Id then
		local inie=tc.initial_effect
		function addinit(c)
			tc.Is_Add_Effect_Id=true
			local _CReg=Card.RegisterEffect
			Card.RegisterEffect=function(card,effect,...)
				if effect then  
					if effect:GetType()&EFFECT_TYPE_GRANT~=0 then
						local labeff=cm.change_effect(effect:GetLabelObject(),count)
						if labeff~=0 then
							local eff=effect:Clone()
							eff:SetLabelObject(labeff)
							_CReg(card,eff,...)
						end
					else
						local eff=cm.change_effect(effect,count)
						if eff~=0 then
							_CReg(card,eff,...)
						end
					end
					return _CReg(card,effect,...)
				end   
			end
			if inie then inie(c) end
			Card.RegisterEffect=_CReg
		end
		cm.initial_effect=addinit
	end
	local g=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0,0xff,nil,rc:GetOriginalCode())
	for tc in aux.Next(g) do
		local mt=getmetatable(tc)
		local ini=cm.initial_effect
		cm.initial_effect=function() end
		tc:ReplaceEffect(id,0)
		cm.initial_effect=ini
		mt.initial_effect=addinit
		tc.initial_effect(tc)
	end
end