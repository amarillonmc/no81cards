--闪刀姬-啼莺
function c77029101.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c77029101.matfilter,3,2,nil,nil,99,nil)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAIABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c77029101.lvtg)
	e1:SetValue(c77029101.lvval)
	c:RegisterEffect(e1)	
	--effect gian
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c77029101.efop)
	c:RegisterEffect(e1)   
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77029101,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,77029101) 
	e2:SetCost(c77029101.spcost)
	e2:SetTarget(c77029101.sptg)
	e2:SetOperation(c77029101.spop)
	c:RegisterEffect(e2) 
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,17029101) 
	e3:SetTarget(c77029101.sptg1)
	e3:SetOperation(c77029101.spop1)
	c:RegisterEffect(e3)
end
function c77029101.matfilter(c)
	return c:IsRace(RACE_MACHINE) or c:IsRace(RACE_WARRIOR)
end
function c77029101.lvtg(e,c)
	return c:IsSetCard(0x115)
end
function c77029101.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 3
	else return lv end
end
function c77029101.effilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa991,0x115)
end
function c77029101.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local cg=c:GetOverlayGroup()
	local wg=cg:Filter(c77029101.effilter,nil,tp)
	local wbc=wg:GetFirst() 
	while wbc do
		local code=wbc:GetOriginalCode()
		if c:GetFlagEffect(code)==0 then 
		local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,1) 
		c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)  
		end 
		wbc=wg:GetNext() 
	end  
end
function c77029101.spfil(c,e,tp,ec) 
	return c:IsSetCard(0xa991,0x115) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c77029101.ckfil(c,ec)
	return ec:CheckRemoveOverlayCard(tp,c:GetLink(),REASON_COST)
end
function c77029101.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	local xg=Duel.GetMatchingGroup(c77029101.spfil,tp,LOCATION_EXTRA,0,nil,e,tp,c)
	local tg=xg:Filter(c77029101.ckfil,nil,c)
	if chk==0 then return tg:GetCount()>0 end 
	local cg=c:GetOverlayGroup()
	local lvt={}
	local tc=tg:GetFirst()
	while tc do
		local tlv=0
		tlv=tlv+tc:GetLink()
		lvt[tlv]=tlv
		tc=tg:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77029101,2))
	local lk=Duel.AnnounceNumber(tp,table.unpack(lvt))
	c:RemoveOverlayCard(tp,lk,lk,REASON_COST)
	e:SetLabel(lk)
end
function c77029101.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c77029101.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lk=e:GetLabel()
	local g=Duel.GetMatchingGroup(c77029101.spfil,tp,LOCATION_EXTRA,0,nil,e,tp,c) 
	local g1=g:Filter(Card.IsLink,nil,lk)
	if g1:GetCount()>0 then 
	local sg=g1:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c77029101.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c77029101.splimit(e,c)
	return not c:IsSetCard(0xa991) and not c:IsSetCard(0x115) and not c:IsCode(52340445)
end
function c77029101.ovfil(c)
	return c:IsSetCard(0xa991,0x115) and c:IsCanOverlay()
end
function c77029101.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(c77029101.ovfil,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SelectTarget(tp,c77029101.ovfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77029101.xovfil(c)
	return c:IsSetCard(0x115,0xa991) and c:IsType(TYPE_MONSTER)
end
function c77029101.spop1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.Overlay(c,tc) 
	if (Duel.CheckLocation(tp,LOCATION_MZONE,5) or Duel.CheckLocation(tp,LOCATION_MZONE,6)) and Duel.SelectYesNo(tp,aux.Stringid(77029101,1)) then 
	Duel.BreakEffect() 
	flag=0
	flag=bit.bor(flag,1)	
	flag=bit.bor(flag,2) 
	flag=bit.bor(flag,4) 
	flag=bit.bor(flag,8)  
	flag=bit.bor(flag,16)
	flag=bit.bor(flag,65536*1)
	flag=bit.bor(flag,65536*2)
	flag=bit.bor(flag,65536*4)
	flag=bit.bor(flag,65536*8)
	flag=bit.bor(flag,65536*16) 
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,flag)   
	nseq=0 
	if s==2097216 then nseq=6
	elseif s==4194336 then nseq=5 end
	Duel.MoveSequence(c,nseq) 
	end
	if Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.IsExistingMatchingCard(c77029101.ovfil,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) and Duel.CheckLPCost(tp,Duel.GetLP(tp)/2) and Duel.SelectYesNo(tp,aux.Stringid(77029101,3)) then 
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2) 
	local sg=Duel.SelectMatchingCard(tp,c77029101.xovfil,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	Duel.Overlay(c,sg)
	end
	end
end








