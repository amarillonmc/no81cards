--圣星之守卫
local s,id,o=GetID()
function c98941055.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCondition(c98941055.sumcon)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetCondition(s.copycon2)
	e4:SetOperation(s.copyop)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetCondition(s.regcon)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
end
function c98941055.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x9c,nil,1000,1900,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x9c,nil,1000,1900,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
	   c:AddMonsterAttribute(TYPE_NORMAL)
	   Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	   --effect gain3
	   local e0=Effect.CreateEffect(c)
	   e0:SetDescription(aux.Stringid(98941055,3))
	   e0:SetType(EFFECT_TYPE_FIELD)
	   e0:SetCode(EFFECT_SPSUMMON_PROC)
	   e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	   e0:SetRange(LOCATION_EXTRA)
	   e0:SetCondition(c98941055.con)
	   e0:SetTarget(c98941055.tg)
	   e0:SetOperation(c98941055.op)
	   e0:SetValue(SUMMON_TYPE_XYZ)
	   local e33=Effect.CreateEffect(c)
	   e33:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	   e33:SetRange(LOCATION_MZONE)
	   e33:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e33:SetTargetRange(LOCATION_EXTRA,0)
	   e33:SetTarget(c98941055.eftg1)
	   e33:SetReset(RESET_EVENT+RESETS_STANDARD)
	   e33:SetLabelObject(e0)
	   c:RegisterEffect(e33,true)
	   Duel.SpecialSummonComplete()
   end
   if Duel.IsExistingMatchingCard(s.sxyzfilter,tp,LOCATION_EXTRA,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c98941055.sxyzfilter,tp,LOCATION_EXTRA,0,nil)
		if g:GetCount()>0 then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		   local tg=g:Select(tp,1,1,nil)
		   Duel.XyzSummon(tp,tg:GetFirst(),nil)
		end
	end
end
function s.sxyzfilter(c,tp)
	return c:IsXyzSummonable(nil) or (c:IsSetCard(0x53,0x9c) and c:IsRank(4) and Duel.GetFlagEffect(tp,c:GetCode())==0)
end
function c98941055.xyzfilter1(c,e,lv,ff)
	if (ff==1 or ff==4) and not c:IsSetCard(0x9c) then return end
	if ff==2 and not c:IsAttribute(ATTRIBUTE_LIGHT) then return end
	if ff==3 and not c:IsSetCard(0x53) then return end
	return c:IsSetCard(0x9c,0x53) and c:IsLevel(4) and c:IsCanBeXyzMaterial(e:GetHandler())
end
function c98941055.xyzfilter2(c,e)
	return c:IsCode(98941055) and c:IsCanBeXyzMaterial(e:GetHandler()) and Duel.GetMZoneCount(c:GetControler(),c,c:GetControler())>0 and c:IsLevel(4)
end
function c98941055.xyzfilter(c,e)
	return c:IsCanBeXyzMaterial(e:GetHandler()) and c:IsLevel(4) 
end
function c98941055.con(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c98941055.xyzfilter,c:GetControler(),LOCATION_DECK,0,1,nil,e) and Duel.GetFlagEffect(tp,c:GetCode())==0
end
function c98941055.tg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	local ff=0
	if c:IsCode(42589641) and not c:IsType(TYPE_PENDULUM) then ff=1
	elseif c:IsCode(2091298) then ff=2
	elseif c:IsCode(26329679) then ff=3
	elseif c:IsCode(64414267) then ff=4 end
	local g1=Duel.GetMatchingGroup(c98941055.xyzfilter1,tp,LOCATION_DECK,0,nil,e,lv,ff)
	local xx=Duel.GetMatchingGroup(c98941055.xyzfilter2,tp,LOCATION_MZONE,0,nil,e):GetFirst()
	local t=2
	local k=1
	if ff==1 then k=2 end
	if ff==3 or ff==4 or ff==2 then t=1 end
	if #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local xg=g1:Select(tp,k,t,nil)
		xg:KeepAlive()
		xg:AddCard(xx)
		e:SetLabelObject(xg)
	return true
	else return false end
end
function c98941055.op(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=e:GetLabelObject()
	local mg2=mg:GetFirst():GetOverlayGroup()
	if mg2:GetCount()~=0 then
	   Duel.Overlay(c,mg2)
	end  
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	local kid=c:GetCode()
	Duel.RegisterFlagEffect(tp,kid,RESET_PHASE+PHASE_END,0,1)
	mg:DeleteGroup()
end
function c98941055.eftg1(e,c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x9c,0x53) and c:IsRank(4)
end
function s.copyfilter(c)
	return c:IsSetCard(0x9c,0x53) and c:IsType(TYPE_MONSTER)
end
function s.copycon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup():Filter(s.copyfilter,nil)
	return g:GetCount()>0 and c:IsSetCard(0x9c,0x53)
end
function s.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetHandler():GetOverlayGroup():Filter(s.copyfilter,nil)
	local tc=g:GetFirst()
	while tc do
		if c:GetFlagEffectLabel(id+tc:GetCode())==nil then
		   local cid=c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESET_TOGRAVE,1)
		   c:RegisterFlagEffect(id+tc:GetCode(),RESET_EVENT+RESET_TOGRAVE,0,1,tc:GetOriginalCode())
		   c:RegisterFlagEffect(id+tc:GetCode()+1,RESET_EVENT+RESET_TOGRAVE,0,1,cid)
		end
		tc=g:GetNext()
   end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup():Filter(s.copyfilter,nil)
	local tc=g:GetFirst()
	while tc do 
		 if not c:GetFlagEffectLabel(id+tc:GetCode())~=tc:GetOriginalCode() then return end
		 tc=g:GetNext()
	end
	return c:GetFlagEffect(15000097)==0
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(s.copyfilter,tp,0xff,0,nil)
	local g=c:GetOverlayGroup():Filter(s.copyfilter,nil)
	local tc=cg:GetFirst()
	while tc do
		if tc and tc:GetOriginalCode()==c:GetFlagEffectLabel(id+tc:GetCode()) then return end
		if c:GetFlagEffectLabel(id+tc:GetCode())==nil then return end
		local sc=g:GetFirst()
		local i=0
		while sc do
		   if sc:GetCode()==tc:GetCode() then i=1 end
		   sc=g:GetNext()
		end
		if i==0 then
			local cid=c:GetFlagEffectLabel(id+tc:GetCode())
			c:ResetEffect(cid,RESET_COPY)
			c:ResetFlagEffect(id+tc:GetCode())
	 		c:ResetFlagEffect(id+tc:GetCode()+1)
	 	end
	 	tc=cg:GetNext()
	end
end