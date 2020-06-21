--罗德岛·行动-干员寻访
function c183.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,183)
	e1:SetTarget(c183.tg)
	e1:SetOperation(c183.op)
	c:RegisterEffect(e1)	
end
function c183.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c183.op(e,tp,eg,ep,ev,re,r,rp)
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,9)))
	local x1=math.random(1,100)
	if x1<=2 then 
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,9)))
	local x2=math.random(1,16)
	if x2==1 then
	local a=Duel.CreateToken(tp,10)
	elseif x2==2 then
	local a=Duel.CreateToken(tp,25) 
	elseif x2==3 then
	local a=Duel.CreateToken(tp,22)  
	elseif x2==4 then
	local a=Duel.CreateToken(tp,34)  
	elseif x2==5 then
	local a=Duel.CreateToken(tp,121) 
	elseif x2==6 then
	local a=Duel.CreateToken(tp,89)
	elseif x2==7 then
	local a=Duel.CreateToken(tp,72)
	elseif x2==8 then
	local a=Duel.CreateToken(tp,88)   
	elseif x2==9 then
	local a=Duel.CreateToken(tp,35)
	elseif x2==10 then 
	local a=Duel.CreateToken(tp,51)  
	elseif x2==11 then
	local a=Duel.CreateToken(tp,30) 
	elseif x2==12 then
	local a=Duel.CreateToken(tp,136) 
	elseif x2==13 then
	local a=Duel.CreateToken(tp,61)
	elseif x2==14 then
	local a=Duel.CreateToken(tp,117) 
	elseif x2==15 then
	local a=Duel.CreateToken(tp,81) 
	elseif x2==16 then
	local a=Duel.CreateToken(tp,99) 

	end
	Duel.SpecialSummon(a,0,tp,tp,true,true,POS_FACEUP)
	elseif x1>=3 and x1<=10 then
	local a=Duel.CreateToken(tp,14)
	Duel.SpecialSummon(a,0,tp,tp,true,true,POS_FACEUP)	
	elseif x1>=11 and x1<=50 then
	local a=Duel.CreateToken(tp,46)
	Duel.SpecialSummon(a,0,tp,tp,true,true,POS_FACEUP)	
	elseif x1>=51 and x1<=100 then
	local a=Duel.CreateToken(tp,12)
	Duel.SpecialSummon(a,0,tp,tp,true,true,POS_FACEUP)
end
end









