--时间旅行者 克劳
local s,id,o=GetID()
function s.initial_effect(c)
	local lmc=Duel.GetRegistryValue("Kro_Link_Marker_Count")
	if lmc then
		s.setlinkmarker(c,tonumber(lmc))
	else
		Duel.SetRegistryValue("Kro_Link_Marker_Count",1)
		s.setlinkmarker(c,1)
	end
	c:EnableReviveLimit()
	--
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH+EFFECT_COUNT_CODE_DUEL)
	e0:SetCondition(s.spcon)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--cannot link material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--limit summons
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(s.lscon)
	e3:SetOperation(s.lsop)
	c:RegisterEffect(e3)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(s.efilter)
	c:RegisterEffect(e5)
	--atk/def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(s.adval)
	c:RegisterEffect(e6)
	--change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22198672,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.chtg)
	e3:SetOperation(s.chop)
	c:RegisterEffect(e3)
end
function s.exmat(g,sc,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON)
	return rg:CheckSubGroup(s.exmat,1,13,c,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,s.exmat,true,1,13,c,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	c:SetMaterial(g)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function s.setlinkmarker(c,mc)
	local sum=0 
	if mc>=8 then
		sum=0x1ff
	else
		local markers = {0x080,0x100,0x020,0x004,0x002,0x001,0x008,0x040}
		for i=1,mc do
			sum=sum+markers[i]
		end
	end
	c:SetCardData(CARDDATA_LEVEL,mc)
	c:SetCardData(CARDDATA_LINK_MARKER,sum)
	if mc==1 then c:SetCardData(CARDDATA_CODE,id) end
	if mc==2 or mc==3 then c:SetCardData(CARDDATA_CODE,id+1) end
	if mc==4 or mc==5 then c:SetCardData(CARDDATA_CODE,id+2) end
	if mc==6 or mc==7 then c:SetCardData(CARDDATA_CODE,id+3) end
	if mc>=8 then c:SetCardData(CARDDATA_CODE,id+4) end
	return sum
end
function s.cfilter(c,cid)
	return c:GetOriginalCode()==cid
end
function s.lscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.lsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	if mg then
		Duel.Hint(HINT_CARD,0,id)
		local lmc=tonumber(Duel.GetRegistryValue("Kro_Link_Marker_Count"))+#mg+8
		Duel.SetRegistryValue("Kro_Link_Marker_Count",lmc)
		local g=Duel.GetFieldGroup(0,0x7f,0x7f)
		local xg=Duel.GetOverlayGroup(0,0x7f,0x7f)
		g:Merge(xg)
		g=g:Filter(s.cfilter,nil,id)
		for tc in aux.Next(g) do
			s.setlinkmarker(tc,lmc)
		end
	end
end
function s.adval(e,c)
	return c:GetLink()*500
end
function s.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP)then return false end
	local lmc=e:GetHandler():GetLink()
	local tc=te:GetHandler()
	return not(tc:GetLevel()>=lmc or tc:GetRank()>=lmc or tc:GetLink()>=lmc)
end
function s.eqfilter(c,tp,lg)
	return (c:IsAbleToChangeControler() or c:IsControler(tp)) and lg:IsContains(c)
end
function s.chcheck(g)
	if #g<2 then return true end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	return tc1:IsControler(tc2:GetControler()) or tc1:IsAbleToChangeControler() and tc2:IsAbleToChangeControler()
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup():Filter(Card.IsCanBeEffectTarget,nil,e)
	if chkc then return false end
	if chk==0 then return lg:CheckSubGroup(s.chcheck,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=lg:SelectSubGroup(tp,s.chcheck,true,2,2)
	Duel.SetTargetCard(g)
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetTargetsRelateToChain()
	if #sg<2 then return end
	local tc1=sg:GetFirst()
	local tc2=sg:GetNext()
	if tc1:IsControler(tc2:GetControler()) then
		Duel.SwapSequence(tc1,tc2)
	else
		local seq1=tc1:GetSequence()
		local seq2=tc2:GetSequence()
		Duel.SwapControl(tc1,tc2)
		if tc2:GetSequence()~=seq1 then Duel.MoveSequence(tc2,seq1) end
		if tc1:GetSequence()~=seq2 then Duel.MoveSequence(tc1,seq2) end
	end
end